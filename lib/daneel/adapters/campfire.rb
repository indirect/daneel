require 'sparks'
require 'daneel/adapter'
require 'daneel/message'

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
        @room.watch do |data|
          next if data["type"] == "timestamp"

          # TODO pass through self-messages, once they are filtered by
          # the accept? method on scripts
          next if data["user_id"] == me["id"]

          type = data["type"].gsub(/Message$/, '').downcase
          message = Message.new(data["body"], data["created_at"], type)
          robot.receive message
        end
      rescue Exception => e
        @room.leave
        raise e
      end

      def say(*texts)
        texts.each do |text|
          text =~ /\n/ ? @room.paste(text) : @room.speak(text)
        end
      end

      def me
        @me ||= @fire.me["user"]
      end

    end
  end
end
