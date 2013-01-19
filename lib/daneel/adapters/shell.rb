require 'daneel/adapter'
require 'daneel/message'
require 'daneel/room'
require 'readline'

module Daneel
  class Adapters
    class Shell < Daneel::Adapter

      def initialize(robot)
        super
        @room = Room.new(1, self)
      end

      def run
        # End the line we were on when we exit
        trap(:EXIT){ print "\n" }

        while text = Readline.readline("> ", true)
          next if text.empty?
          message = Message.new(text, @room, Time.now, "text")
          robot.receive @room, message
        end
      end

      def say(id, *strings)
        puts *strings
      end

      def announce(*strings)
        say @room.id, *strings
      end

    end
  end
end
