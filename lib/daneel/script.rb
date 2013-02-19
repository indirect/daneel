require 'daneel/plugin'

module Daneel
  class Script < Plugin
    attr_reader :message, :robot, :room, :user

    def initialize(robot, room, user, message)
      @robot, @room, @user, @message = robot, room, user, message
    end

    def run
      # do stuff here!
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
      accept_type = types.include?(message.type)

      sent_to = accept[:sent_to] || :me
      accept_sent_to = sent_to == :anyone || (sent_to == :me && message.command)

      match = accept[:match] || [/.*/]
      accept_match = match.find{|p| p.match(message.text) }

      accept_type && accept_sent_to && accept_match
    end

    def self.accept
      @accept ||= {}
    end

    def self.handles(*types)
      accept[:types] = types.map{|t| t.to_s } unless types.empty?
    end

    def self.sent_to(whom)
      accept[:sent_to] = whom
    end

    def self.match(*patterns)
      accept[:match] = patterns unless patterns.empty?
    end

  end
end
