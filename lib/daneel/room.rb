module Daneel
  class Room
    attr_reader :id

    def initialize(id, adapter)
      @id, @adapter = id, adapter
    end

    def say(*strings)
      @adapter.say @id, *strings
    end

    def inspect
      %|#<#{self.class} @id=#{@id.inspect} @adapter=#{@adapter.class}|
    end

  end
end