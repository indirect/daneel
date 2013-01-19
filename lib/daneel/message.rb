require 'shellwords'

module Daneel
  class Message
    attr_reader :command, :finished, :room, :text, :time, :type
    attr_accessor :args, :user

    def initialize(text, room_id, time = Time.now, type = :text)
      @text, @room, @time, @type = text, room, time, type
    end

    def command=(text)
      @command = text
      @args = text ? Shellwords.split(text) : nil
    end

    def finish!
      @finished = true
    end

    def to_s
      text || "#<#{self.class} #{time.inspect} #{type.inspect} " +
        "@room=#{@room} @finished=#{@finished}>"
    end

  end
end