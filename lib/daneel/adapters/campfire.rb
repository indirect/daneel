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
        @rooms = ENV['CAMPFIRE_ROOM_IDS'].split(",").map(&:to_i)
      end

      def run
        @room_threads ||= {}
        @rooms.each do |room_id|
          room = @fire.room(room_id)
          thread = Thread.new { watch_room(room) }
          @room_threads.merge!(room_id => thread)
        end
      end

      def say(*texts)
        texts.each do |text|
          text =~ /\n/ ? @room.paste(text.to_s) : @room.speak(text.to_s)
        end
      end

      def leave
        @rooms.each do |room_id|
          # stop the thread listening to this room
          @room_threads[room_id].kill
          # leave the room
          @fire.room(room_id).leave
        end
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

          type = data["type"].gsub(/Message$/, '').downcase
          message = Message.new(data["body"], data["created_at"], type)
          robot.receive message
        end
      end

    end
  end
end
