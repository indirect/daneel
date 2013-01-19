require 'sparks'
require 'daneel/adapter'
require 'daneel/message'

module Daneel
  class Adapters
    class Campfire < Daneel::Adapter
      required_env %w(CAMPFIRE_SUBDOMAIN CAMPFIRE_API_TOKEN CAMPFIRE_ROOM_IDS)

      def initialize(robot)
        super
        domain = ENV['CAMPFIRE_SUBDOMAIN']
        token  = ENV['CAMPFIRE_API_TOKEN']
        @fire  = Sparks::Campfire.new(domain, token, :logger => logger)
        @rooms = {}
        ENV['CAMPFIRE_ROOM_IDS'].split(",").map(&:to_i).each do |id|
          @rooms[id] = @fire.room(id)
        end
      end

      def run
        @threads ||= []
        @rooms.each do |id, room|
          @threads << Thread.new { watch_room(room) }
        end
      end

      def say(room_id, *texts)
        room = @fire.room(room_id)
        texts.each do |text|
          text =~ /\n/ ? room.paste(text.to_s) : room.speak(text.to_s)
        end
      end

      def leave
        # stop the listening threads
        @threads.each{|t| t.kill }
        # leave each room
        @rooms.each{|i, r| r.leave }
      end

      def room(id)
        @rooms.find{|r| r.id == id }
      end

      def me
        @me ||= @fire.me["user"]
      end

      def watch_room(room)
        room.watch do |data|
          next if data["type"] == "TimestampMessage"

          # TODO pass through self-messages, once they are filtered by
          # the accept? method on scripts
          next if data["user_id"] == me["id"]

          text = data["body"]
          room = data["room_id"].to_i
          time = Time.parse(data["created_at"]) rescue Time.now
          type = data["type"].gsub(/Message$/, '').downcase
          message = Message.new(text, room, time, type)
          robot.receive message
        end
      end

    end
  end
end
