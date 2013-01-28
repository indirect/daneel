require 'daneel/plugin'

module Daneel
  class Script < Plugin

    def accepts?(room, message, user)
      true unless user.id == robot.user.id
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
