require 'daneel/bot'
require 'daneel/logger'
require 'daneel/options'
require 'daneel/version'

module Daneel
  def self.script_list
    @script_list ||= []
  end

  def self.script_files
    Dir[File.expand_path("../daneel/scripts/chatty*.rb", __FILE__)]
  end

end
