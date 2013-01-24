require 'daneel/adapter'
require 'readline'

module Daneel
  class Adapters
    class Shell < Daneel::Adapter

      def initialize(robot)
        super
        @room = Room.new("shell", self)
        @user = User.new(1, ENV['USER'])
      end

      def run
        # End the line we were on when we exit
        trap(:EXIT){ print "\n" }

        while text = Readline.readline("> ", true)
          next if text.empty?
          message = Message.new(text, Time.now, "text")
          robot.receive @room, message, @user
        end
      end

      def say(id, *strings)
        puts *strings
      end

      def announce(*strings)
        puts
        say @room.id, *strings
      end

    end
  end
end
