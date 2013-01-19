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

          options[:server] = {:port => port}
        opts.on("-s", "--server", "[PORT]", "Run the HTTP server on PORT (default 3333)") do |port|
        end

        opts.on("-a", "--adapter ADAPTER", "Which interaction adapter to use") do |name|
          options[:adapter] = name
        end

        opts.on("-n", "--name NAME", "The name your bot should respond to") do |name|
          options[:name] = name
        end

        opts.on("-f", "--full-name FULLNAME", "The name your bot will use to refer to itself") do |name|
          options[:full_name] = name
        end
      end.parse(args)

      return options
    end

  end
end
