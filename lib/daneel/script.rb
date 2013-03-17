require 'daneel/plugin'

module Daneel
  class Script < Plugin
    attr_reader :message, :robot, :room, :user

    def initialize(robot, room, user, message)
      @robot, @room, @user, @message = robot, room, user, message
    end

    def run
      # do stuff here!
      # respond(/hi/){ say "hello there" }
      # listen(/trololol/){ say ":trollface:" }
    end

    def usage
      # a hash of commands that map to descriptions
      {}
    end

    def help
      # A heredoc with long-form help
      <<-HELP
        We know... nothink.
      HELP
    end

  private

    def process(*patterns, string)
      return if message.done || string.nil?
      match = nil
      if patterns.find { |p| match = string.match(p) }
        yield *match.captures
        message.done!
      end
    end

    def listen(*patterns)
      process(*patterns, message.text) { |*args| yield *args }
    end

    def respond(*patterns)
      process(*patterns, message.command) { |*args| yield *args }
    end

    def me
      @robot.user
    end

    def data
      @robot.data
    end

    def reply(*strings)
      @robot.reply room, user, *strings
    end

    def say(*strings)
      @robot.say room, *strings
    end

    # Class methods


    # Track scripts that have loaded so we can use them
    def self.inherited(subclass)
      Daneel.loaded_scripts << subclass
    end

    # @param room the room the message was said into
    # @param user the user that said the message
    # @param message the message that is being checked
    # @returns [Boolean] Whether this script can handle the message
    def self.handles?(room, user, message)
      types = @handles_types || ["text"]
      types.include?(message.type.to_s)
    end

    # @param *types A list of message types this script can process. If no
    # value is set, the script will only handle the message type "text".
    def self.handles(*types)
      @handles_types = types.map(&:to_s) unless types.empty?
    end

  end
end
