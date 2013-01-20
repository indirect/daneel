module Daneel
  # Represents a generic user. Doesn't have a room, because multiple rooms can
  # contain the same user. The user's unique identifier is supplied by the
  # adapter, and only needs to be unique within the context of that adapter.
  class User
    attr_reader :id, :name
    attr_accessor :data

    def initialize(id, name, data = nil)
      @id, @name, @data = id, name, data
    end

  end
end