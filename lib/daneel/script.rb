require 'daneel/plugin'

module Daneel
  class Script < Plugin

    # Track scripts that have loaded so we can use them
    class << self
      def list
        @list ||= []
      end

      def inherited(subclass)
        list << subclass
      end
    end

    def accept?(message)
      true
      # TODO default to accepting messages that aren't our own
      # message.user != robot.user
    end

    def receive(message)
      logger.error "#{self.class} hasn't defined \#receive"
    end

    def help
      # return a hash of commands and descriptions for help listings
    end

    # Provide say as a convenience for other scripts
    def say(message)
      robot.adapter.say(message)
    end

  end
end
