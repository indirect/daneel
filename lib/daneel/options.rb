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

        opts.on("-s", "--server [PORT]", "Run the HTTP server on PORT (default 3333)") do |port|
          options[:server] = {:port => port}
        end

        opts.on("-a", "--adapter ADAPTER", "Which interaction adapter to use") do |name|
          options[:adapter] = name
        end
      end.parse(args)

      return options
    end

  end
end
