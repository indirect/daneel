require 'daneel/message'
require 'daneel/plugin'
require 'daneel/room'
require 'daneel/user'

module Daneel
  class Adapter < Plugin

    def run
      logger.error "#{self.class} hasn't defined \#run"
    end

    def say(room_id, message)
      logger.error "#{self.class} hasn't defined \#say"
    end

    def say_all(message)
      logger.error "#{self.class} hasn't defined \#say"
    end

    class << self
      def named(name)
        require File.join('daneel/adapters', name.downcase)
        adapter = Daneel::Adapters.const_get(name.capitalize)
        adapter || raise("Couldn't find Daneel::Adapters::#{a.capitalize}")
      end
    end

  end
end
