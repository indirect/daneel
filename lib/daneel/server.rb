require 'net/http/persistent'
require 'daneel'

module Daneel
  class Server
    attr_reader :logger

    def initialize(options = {})
      require 'daneel/web'
      @logger = options[:logger] || Daneel::Logger.new
      @options = {:app => Daneel::Web, :server => "puma"}.merge(options)
      @options[:port] = ENV["PORT"] if ENV["PORT"]
      # Rack expects the port key to be capitalized. Sad day.
      @options[:Port] = @options.delete(:port) if @options[:port]
      logger.debug "Server with options: #{@options}"
    end

    def run
      Thread.new { run_server }
      Thread.new { run_self_ping } if ENV['HEROKU_URL']
    end

    def run_server
      Rack::Server.start(@options)
    end

    def run_self_ping
      sleep 1 # boot server before allowing possible interaction
      uri = URI(ENV['HEROKU_URL'])
      http = Net::HTTP::Persistent.new 'daneel'
      loop do
        http.request uri
        sleep (60 * 2) # 2m
      end
    end

  end
end
