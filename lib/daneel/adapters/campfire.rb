require 'sparks'
require 'daneel/adapter'

module Daneel
  class Adapters
    class Campfire < Daneel::Adapter
      requires_env %w(CAMPFIRE_SUBDOMAIN CAMPFIRE_API_TOKEN CAMPFIRE_ROOM_IDS)

      def initialize(robot)
        super
        domain = ENV['CAMPFIRE_SUBDOMAIN']
        token  = ENV['CAMPFIRE_API_TOKEN']
        @fire  = Sparks.new(domain, token, :logger => logger)

        ENV['CAMPFIRE_ROOM_IDS'].split(",").map do |id|
          robot.data.rooms[id.to_i] ||= Room.new(id.to_i, self, @fire.room(id))
        end
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
          text =~ /\n/ ? @fire.paste(id, text) : @fire.speak(id, text)
        end
      end

      def announce(*texts)
        @rooms.each do |room|
          say room.id, *texts
        end
      end

      def leave
        # stop the listening threads
        @threads.each{|t| t.kill }
        # leave each room
        @rooms.each{|r| @fire.room(r.id).leave }
      end

      def me
        @me ||= begin
          data = @fire.me
          me = User.new(data["id"], data["name"], data)
          robot.data.users[me.id] = me
        end
      end

    private

      def watch_room(room)
        @fire.watch(room.id) do |data|
          next if data["type"] == "TimestampMessage"

          # TODO pass through self-messages, once they are filtered by
          # the accept? method on scripts
          next if data["user_id"] == me.id

          text = data["body"]
          time = Time.parse(data["created_at"]) rescue Time.now
          type = data["type"].gsub(/Message$/, '').downcase
          mesg = Message.new(text, time, type)
          room = robot.data.rooms(data["room_id"])
          user = robot.data.users(data["user_id"])
          robot.receive room, mesg, user
        end
      end

    end
  end
end
