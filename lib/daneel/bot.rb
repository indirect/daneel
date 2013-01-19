require 'logger'
require 'daneel/adapter'
require 'daneel/script'

module Daneel
  class Bot
    attr_reader :adapter, :full_name, :logger, :name, :scripts
    attr_accessor :debug_mode

    def initialize(options = {})
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless options[:verbose]
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity} [#{Process.pid}] #{msg}\n"
      end
      @logger.debug "Created with options #{options.inspect}"

      @name = options[:name] || "daneel"
      @full_name = options[:full_name] || options[:name] || "R. Daneel Olivaw"
      @debug_mode = true # who are we kidding

      @scripts = Script.require_all.map{|k| k.new(self) }
      logger.debug "Booted with scripts: #{@scripts.map(&:class).inspect}"

      # Load the adapter
      @adapter = Adapter.named(options[:adapter] || "shell").new(self)
      logger.debug "Using the #{adapter.class} adapter"
    end

    def receive(room, message)
      logger.debug "Got message: #{message.text} in room #{room.id}"
      message.command = command_from(message.text)

      scripts.each do |script|
        script.receive room, message
        break if message.finished
      end

      return message
    rescue => e
      msg = "#{e.class}: #{e.message}\n  #{e.backtrace.join('  \n')}"
      logger.error msg
      adapter.say "crap, something went wrong. :(", msg if @debug_mode
    end

    def run
      # TODO add i18n so that people can customize their bot's attitude
      # TODO add Confabulator processing so the bot can be chatty without being static
      #   http://titusd.co.uk/2010/03/04/i18n-internationalization-without-rails/
      @adapter.run
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
