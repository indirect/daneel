require 'net/http/persistent'

module Daneel
  class Server

    def initialize(options = {})
      require 'daneel/web'
      @options = {
        :app => Daneel::Web, :server => "puma",
        :port => ENV["PORT"] || "3333"
      }.merge(options)
      # Rack expects the port key to be capitalized. Sad day.
      @options[:Port] = @options.delete(:port) if @options[:port]
    end

    def run
      Thread.new { run_server }
      Thread.new { run_self_ping }
      sleep 0.1 # boot server before allowing possible interaction
    end

    def run_server
      Rack::Server.start(@options)
    end

    def run_self_ping
      return unless ENV['HEROKU_URL']
      uri = URI(ENV['HEROKU_URL'])
      http = Net::HTTP::Persistent.new 'daneel'
      loop do
        http.request uri
        # Heroku kills dynos after 1h
        sleep (60 * 60) - 5
      end
    end

  end
end