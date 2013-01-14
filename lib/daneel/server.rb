module Daneel
  class Server

    def initialize(options = {})
      require 'daneel/web'
      @options = {
        :app => Daneel::Web, :server => "puma",
        :port => ENV["PORT"] || "3333"
      }.merge(options)
    end

    def run
      # Rack expects the port key to be capitalized. Sad day.
      @options[:Port] = @options.delete(:port) if @options[:port]
      Thread.new { Rack::Server.start(@options) }

      # TODO self-ping to not die on heroku

      sleep 0.1 # boot server before allowing possible interaction
    end

  end
end