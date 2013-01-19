require 'sparks'
require 'daneel/adapter'

module Daneel
  class Adapters
    class Campfire < Daneel::Adapter
      required_env %w(CAMPFIRE_SUBDOMAIN CAMPFIRE_API_TOKEN CAMPFIRE_ROOM_IDS)

      def initialize(robot)
        super
        domain = ENV['CAMPFIRE_SUBDOMAIN']
        token  = ENV['CAMPFIRE_API_TOKEN']
        @rooms = ENV['CAMPFIRE_ROOM_IDS'].split(",").map do |id|
          Room.new(id.to_i, self)
        end
        @fire  = Sparks::Campfire.new(domain, token, :logger => logger)
      end

      def run
        @threads ||= []
        @rooms.each do |room|
          t = Thread.new { watch_room(room) } until t
          t.abort_on_exception = true
          @threads << t
        end
        @threads.each{|t| t.join }
      end

      def say(id, *texts)
        texts.each do |text|
          if text =~ /\n/
            @fire.room(id).paste(text.to_s)
          else
            @fire.room(id).speak(text.to_s)
          end
        end
      end

      def announce(*texts)
        @rooms.each do |room|
          say room.id, *texts
        end
        texts
      end

      def leave
        # stop the listening threads
        @threads.each{|t| t.kill }
        # leave each room
        @rooms.each{|r| @fire.room(r.id).leave }
      end

      def me
        @me ||= @fire.me
      end

      def watch_room(room)
        @fire.room(room.id).watch do |data|
          next if data["type"] == "TimestampMessage"

          # TODO pass through self-messages, once they are filtered by
          # the accept? method on scripts
          next if data["user_id"] == me["id"]

          text = data["body"]
          room = @rooms.find{|r| r.id == data["room_id"] }
          time = Time.parse(data["created_at"]) rescue Time.now
          type = data["type"].gsub(/Message$/, '').downcase
          message = Message.new(text, room, time, type)
          robot.receive room, message
        end
      end

    end
  end
end
