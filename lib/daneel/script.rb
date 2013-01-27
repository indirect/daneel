require 'daneel/plugin'

module Daneel
  class Script < Plugin

    def accept?(message)
      true
      # TODO default to accepting messages that aren't our own
      # message.user != robot.user
    end

    def receive(room, message, user)
      # do stuff here!
    end

    def help
      # return a hash of commands and descriptions for help listings
      {}
    end

    # Track scripts that have loaded so we can use them
    class << self

      def list
        @list ||= []
      end

      def inherited(subclass)
        list << subclass
      end

      def files
        Dir[File.expand_path("../scripts/*.rb", __FILE__)]
      end

      # TODO accept method for script classes
      # should handle options like :text, :enter, :leave, :topic, :all
    end

  end
end
