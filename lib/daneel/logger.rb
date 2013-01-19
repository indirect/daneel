require 'logger'

module Daneel
  class Logger < ::Logger

    def initialize(io = $stdout, verbose = false)
      super
      self.level = Logger::INFO unless verbose
      self.formatter = proc do |severity, datetime, progname, msg|
        "#{severity} #{msg}\n"
      end
      p self
    end

    def inspect
      %|#<#{self.class}:#{object_id} @level=#{level}>|
    end

  end
end
