require 'shellwords'

module Daneel
  class Message
    attr_reader :command, :finished, :text, :time, :type
    attr_accessor :args
    # TODO add user to message for replies
    # TODO add room to message for replies

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

    def to_s
      text
    end

  end
end