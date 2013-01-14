require 'logger'
require 'daneel/adapter'
require 'daneel/options'
require 'daneel/script'
require 'daneel/server'
require 'daneel/version'

module Daneel
  class Bot
    attr_reader :adapter, :logger, :name, :scripts

    def initialize(options = Options.parse(ARGV))
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless options[:verbose]
      @logger.debug "Created with options #{options.inspect}"

      @name   = options[:name] || "daneel"
      @server = Server.new(options[:server]) if options[:server]

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
    end

    def run
      # break off a thread to run the web server
      @server.run if @server
      # announce bootup
      @adapter.say "hey guys"
      # start the main event loop
      @adapter.run
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
