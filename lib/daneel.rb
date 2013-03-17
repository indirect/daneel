require 'daneel/bot'
require 'daneel/logger'
require 'daneel/options'
require 'daneel/version'

module Daneel

  def self.loaded_scripts
    @loaded_scripts ||= []
  end

  class ScriptList

    def initialize(location)
      @location = location
    end

    def safe_require(path)
      require path
    rescue Script::DepError => e
      logger.warn "Couldn't load #{File.basename(name)}: #{e.message}"
    end

    def loaded
      @loaded ||= begin
        files = Dir[File.join(@location, "*.rb")]
        files.each { |f| safe_require(f) }
        Daneel.loaded_scripts.sort_by(&:priority)
      end
    end

    include Enumerable

    def each(*args)
      loaded.each(*args) { |*a| yield *a }
    end

  end

end
