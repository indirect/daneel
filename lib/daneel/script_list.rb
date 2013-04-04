module Daneel
  module ScriptList

    def self.loaded_scripts
      @loaded_scripts ||= []
    end

    def self.load_from(location)
      script_files = Dir[File.join(location, "*.rb")]
      script_files.each{|f| require(f) }
      loaded_scripts.sort!{|a,b| a.priority <=> b.priority }
      self
    end

  end
end
