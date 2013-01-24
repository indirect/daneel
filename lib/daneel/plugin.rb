module Daneel
  class Plugin
    attr_reader :robot

    def initialize(robot)
      @robot = robot
    end

    def logger
      robot.logger
    end

    class DepError < LoadError; end

    def requires_env(*keys)
      keys.flatten.each do |key|
        raise DepError, "#{self} requires ENV['#{key}'] to work" unless ENV[key]
      end
    end

  end
end
