require 'daneel/adapter'
require 'daneel/script'
require 'daneel/data'

module Daneel
  class Bot
    attr_reader :adapter, :data, :full_name, :logger, :name, :scripts
    attr_accessor :debug_mode

    def initialize(options = {})
      @logger = options[:logger] || Daneel::Logger.new
      @name = options[:name] || "daneel"
      @full_name = options[:full_name] || options[:name] || "R. Daneel Olivaw"
      @debug_mode = options[:verbose] && options[:adapter] && options[:adapter] != "shell"

      @data = Data.new
      logger.debug "Data source #{data.class}"

      Script.files.each{|file| try_require file }
      # TODO add script priorities to replicate this
      list = Script.list
      list.push list.delete(Scripts::Chatty)
      @scripts = list.map{|s| s.new(self) }
      logger.debug "Booted with scripts: #{@scripts.map(&:class).inspect}"

      @adapter = Adapter.named(options[:adapter] || "shell").new(self)
      logger.debug "Using the #{adapter.class} adapter"
    end

    def receive(room, message, user)
      logger.debug "[room #{room.id}] #{user.name}: #{message.text}"
      message.command = command_from(message.text)

      scripts.each do |script|
        next unless script.accepts?(room, message, user)
        script.receive(room, message, user)
        break if message.done
      end
      message
    rescue => e
      msg = %|#{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}|
      logger.error msg
      adapter.announce "crap, something went wrong. :(", msg if @debug_mode
    end

    def run
      # TODO add i18n so that people can customize their bot's attitude
      # http://titusd.co.uk/2010/03/04/i18n-internationalization-without-rails/
      # TODO add Confabulator processing so the bot can be chatty without being static

      # Heroku cycles every process at least once per day by sending it a TERM
      trap(:TERM) do
        @adapter.announce "asked to stop, brb"
        exit
      end

      @adapter.announce "hey guys"
      @adapter.run
    rescue Interrupt
      adapter.leave
    end

    def user
      @adapter.me
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

    def try_require(name)
      require name
    rescue Script::DepError => e
      logger.warn "Couldn't load #{File.basename(name)}: #{e.message}"
    end

  end
end
