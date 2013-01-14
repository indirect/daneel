require 'daneel/plugin'

module Daneel
  class Adapter < Plugin

    class << self
      def named(name)
        require File.join('daneel/adapters', name.downcase)
        adapter = Daneel::Adapters.const_get(name.capitalize)
        adapter || raise("Couldn't find Daneel::Adapters::#{a.capitalize}")
      end
    end

    def run
      logger.error "#{self.class} hasn't defined \#run"
    end

    def say(message)
      logger.error "#{self.class} hasn't defined \#say"
    end

  end
end
