require 'daneel/adapter'
require 'sparks'

module Daneel
  class Adapters
    class Campfire < Daneel::Adapter
      required_env %w(CAMPFIRE_SUBDOMAIN CAMPFIRE_TOKEN CAMPFIRE_ROOM)

      def initialize(robot)
        super
        domain = ENV['CAMPFIRE_SUBDOMAIN']
        token  = ENV["CAMPFIRE_TOKEN"]
        name   = ENV["CAMPFIRE_ROOM"]
        @fire  = Sparks::Campfire.new(domain, token, :logger => logger)
        # TODO handle more than one room
        @room  = @fire.room_named(name)
      end

      def run
        @room.watch do |message|
          receive message
        end
      rescue Exception => e
        @room.leave
        raise e
      end

      def receive(message)
        # TODO pass through self-messages, once they are filtered by
        # the accept? method on scripts
        return if message["user_id"] == me["id"]
        return if message["type"] == "TimestampMessage"
        robot.receive message["body"]
      end

      def say(message)
        @room.speak(message)
      end

      def me
        @me ||= @fire.me["user"]
      end

    end
  end
end
