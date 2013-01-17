require 'optparse'

module Daneel
  module Options

    def self.parse(args)
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: daneel [options]"

        opts.on("-v", "--verbose", "Print debugging information") do |v|
          options[:verbose] = v
        end

        opts.on("-s", "--server", "Run the HTTP server as well as the adapter") do |s|
          options[:server] = {}
        end

        opts.on("-p", "--port", "Set the port that the HTTP server will run on") do |p|
          if options[:server]
            options[:server][:port] = p
          else
            abort("the --port option requires that you set the --server option as well")
          end
        end

        opts.on("-a", "--adapter=NAME", "Which interaction adapter to use") do |name|
          options[:adapter] = name
        end

        opts.on("-n", "--name=NAME", "The name your bot should respond to") do |name|
          options[:name] = name
        end

        opts.on("-f", "--full-name=NAME", "The name your bot will use to refer to itself") do |name|
          options[:full_name] = name
        end
      end.parse(args)

      return options
    end

  end
end
