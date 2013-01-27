module Daneel
  class Room
    attr_reader :id
    attr_accessor :data

    def initialize(id, adapter, data = nil)
      @id, @adapter, @data = id, adapter, data
    end

    def say(*strings)
      @adapter.say @id, *strings
    end

    def inspect
      %|#<#{self.class} @id=#{@id.inspect} @adapter=#{@adapter.class}|
    end

  end
end