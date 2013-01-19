require 'daneel/adapter'
require 'daneel/message'
require 'readline'

module Daneel
  class Adapters
    class Shell < Daneel::Adapter

      def run
        # End the line we were on when we exit
        trap(:EXIT){ print "\n" }

        while text = Readline.readline("#{@robot.name}> ", true)
          next if text.empty?
          message = Message.new(text, "shell", Time.now, "text")
          robot.receive message
        end
      end

      def say(room, text)
        say_all text
      end

      def say_all(text)
        puts text
      end

    end
  end
end
