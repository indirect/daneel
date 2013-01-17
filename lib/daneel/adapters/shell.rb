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
          message = Message.new(text, Time.now, "text")
          robot.receive message
        end
      end

      def say(message)
        puts message
      end

    end
  end
end
