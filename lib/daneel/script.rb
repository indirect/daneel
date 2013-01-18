require 'daneel/plugin'

module Daneel
  class Script < Plugin

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


    # Track scripts that have loaded so we can use them
    class << self
      def list
        @list ||= []
      end

      def inherited(subclass)
        list << subclass
      end

      def require_all
        glob = File.expand_path("../scripts/*.rb", __FILE__)
        Dir[glob].each{|script| require script }
        return list
      end

      # TODO accept method for script classes
      # should handle options like :text, :enter, :leave, :topic, :all
    end

  end
end
