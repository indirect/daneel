module Daneel
  class Plugin
    attr_reader :robot

    def initialize(robot)
      @robot = robot
    end

    def logger
      robot.logger
    end

    def self.requires_env(*keys)
      keys.flatten.each do |key|
        raise "#{self} requires ENV['#{key}'] to work" unless ENV[key]
      end
    end

  end
end
