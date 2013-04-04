require 'daneel/bot'
require 'daneel/logger'
require 'daneel/options'
require 'daneel/version'

module Daneel
  module ScriptList
    extend self

    def loaded_scripts
      @loaded_scripts ||= []
    end

    def load_from(location)
      script_files = Dir[File.join(location, "*.rb")]
      script_files.each{|f| require(f) }
      loaded_scripts.sort!{|a,b| a.priority <=> b.priority }
      self
    end

  end
end
