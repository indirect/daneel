require 'shellwords'

module Daneel
  class Message
    attr_reader :command, :done, :room, :text, :time, :type
    attr_accessor :args

    def initialize(text, time = Time.now, type = :text)
      @text, @time, @type = text, time, type
    end

    def command=(text)
      @command = text
      @args = text ? Shellwords.split(text) : nil
    end

    def finish!
      @finished = true
    end

    def inspect
      "#<#{self.class} #{text.inspect} #{time.inspect} #{type.inspect}>"
    end

  end
end