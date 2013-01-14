require 'logger'
require 'daneel/adapter'
require 'daneel/options'
require 'daneel/script'
require 'daneel/server'
require 'daneel/version'

module Daneel
  class Bot
    attr_reader :adapter, :full_name, :logger, :name, :scripts
    attr_accessor :debug_mode

    def initialize(options = Options.parse(ARGV))
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless options[:verbose]
      @logger.debug "Created with options #{options.inspect}"

      @name = options[:name] || "daneel"
      @full_name = options[:full_name] || options[:name] || "R. Daneel Olivaw"
      @server = Server.new(options[:server]) if options[:server]
      @debug_mode = true # who are we kidding

      # Load the echo script as a fallback
      require 'daneel/scripts/echo' if Script.list.empty?
      require 'daneel/scripts/reload'
      require 'daneel/scripts/help'
      @scripts = Script.list.map{|k| k.new(self) }
      logger.debug "Booted with scripts: #{@scripts.map(&:class).inspect}"

      # Load the adapter
      @adapter = Adapter.named(options[:adapter] || "shell").new(self)
      logger.debug "Using the #{adapter.class} adapter"
    end

    def receive(message)
      logger.debug "Got message: #{message}"
      message.command = command_from(message.text)

      scripts.each do |script|
        script.receive message
        break if message.finished
      end
    rescue => e
      msg = "#{e.class}: #{e.message}\n  #{e.backtrace.join('  \n')}"
      logger.error msg
      adapter.say "crap, something went wrong. :(", msg if @debug_mode
    end

    def run
      @server.run if @server
      adapter.say "Greetings. #{full_name}, ready to assist."
      adapter.run
    rescue Interrupt
      adapter.leave
    end

    def inspect
      %|#<#{self.class}:#{object_id} @name="#{name}" @adapter=#{adapter.class}>|
    end

  private

    def command_from(text)
      return if text.nil? || text.empty?
      m = text.match(/^@#{name}\s+(.*)/i)
      m ||= text.match(/^#{name}(?:[,:]\s*|\s+)(.*)/i)
      m ||= text.match(/^\s*(.*?)(?:,\s*)?\b#{name}[.!?\s]*$/i)
      m && m[1]
    end

  end
end
