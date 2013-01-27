require 'daneel/message'
require 'daneel/plugin'
require 'daneel/room'
require 'daneel/user'

module Daneel
  class Adapter < Plugin

    def run
      # listen to rooms and dispatch messages to robot.receive
    end

    def say(room_id, message)
      # get the message into the room!
    end

    def say_all(message)
      # say the message into every room the bot is in
    end

    class << self
      def named(name)
        require File.join('daneel/adapters', name.downcase)
        adapter = Daneel::Adapters.const_get(name.capitalize)
        adapter || raise("Couldn't find Daneel::Adapters::#{a.capitalize}")
      end
    end

  end
end
