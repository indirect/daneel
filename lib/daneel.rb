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

    def load_all
      files = Dir[File.join(@location, "*.rb")]
      files.each { |f| safe_require(f) }
      @loaded = Daneel.loaded_scripts
    end

    def safe_require(path)
      require path
    rescue Script::DepError => e
      logger.warn "Couldn't load #{File.basename(name)}: #{e.message}"
    end

    include Enumerable

    def each(*args)
      load_all unless @loaded
      Daneel.loaded_scripts.each(*args) { |*bargs| yield *bargs }
    end

  end

end
