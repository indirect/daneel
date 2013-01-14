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

        opts.on("--adapter=NAME", "Which interaction adapter to use") do |name|
          options[:adapter] = name
        end
      end.parse(args)

      return options
    end

  end
end
