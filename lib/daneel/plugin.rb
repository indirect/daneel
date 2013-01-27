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

    def self.requires_env(*keys)
      missing = keys.flatten.select{|k| ENV[k].nil? || ENV[k].empty? }
      raise DepError, "#{missing.join(',')} must be set" if missing.any?
    end

  end
end
