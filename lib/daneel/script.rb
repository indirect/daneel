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
      return if message.done
      if string && patterns.any?{|p| string.match(p) }
        message.done!
        yield *Regexp.last_match.captures
      end
    end

    def listen(*patterns)
      process(*patterns, message.text){|*args| yield *args }
    end

    def respond(*patterns)
      process(*patterns, message.command){|*args| yield *args }
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
      Daneel.script_list << subclass
    end

    def self.accepts?(room, user, message)
      types = accept[:type] || ["text"]
      return false unless types.include?(message.type)

      sent_to = accept[:sent_to] || :me
      for_me = sent_to == :me && message.command
      return false unless sent_to == :anyone || for_me

      match = accept[:match] || [/.*/]
      return false unless match.find{|p| p.match(message.text) }

      true
    end

    def self.accept
      @accept ||= {}
    end

    # @param *types A list of message types this script can process, with a
    # default value of "text" if no other value is set.
    def self.handles(*types)
      accept[:types] = types.map(&:to_s) unless types.empty?
    end

    # @param whom Set to :anyone to process all messages that are seen by the
    # bot. Defaults to :me, which means only messages addressed to the bot by
    # name will be processed.
    def self.sent_to(whom)
      accept[:sent_to] = whom.to_sym
    end

    # @param *patterns An optional list of regular expressions that messages
    # will be checked against before the #run method is called. If the script
    # has different behaviour depending on which regex matches, use the block
    # methods #listen and #respond inside of #run instead of this method.
    def self.match(*patterns)
      accept[:match] = patterns unless patterns.empty?
    end

  end
end
