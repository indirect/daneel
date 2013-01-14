require 'daneel/adapter'
require 'readline'

module Daneel
  class Adapters
    class Shell < Daneel::Adapter

      def run
        # End the line we were on when we exit
        trap(:EXIT){ print "\n" }

        while message = Readline.readline("#{@robot.name}> ", true)
          robot.receive message unless message.empty?
        end
      end

      def say(message)
        puts message
      end

    end
  end
end
