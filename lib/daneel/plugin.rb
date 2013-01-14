module Daneel
  class Plugin
    attr_reader :robot

    def initialize(robot)
      @robot = robot
    end

    def logger
      robot.logger
    end

    def self.required_env(keys)
      keys.each do |key|
        raise "#{key} is required!" unless ENV[key]
      end
    end

  end
end
