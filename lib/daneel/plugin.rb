module Daneel
  class Plugin
    attr_reader :robot

    def initialize(robot)
      @robot = robot
    end

    def logger
      robot.logger
    end

  end
end
