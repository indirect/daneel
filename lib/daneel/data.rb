module Daneel
  # Non-persistent storage, extend if you want more.
  class Data

    def initialize
      @store = {}
    end

    def save
      # it's a hash, what do you want?
    end

    def [](key)
      @store[key]
    end

    def []=(key, value)
      @store[key] = value
    end

    def users
      @store["users"] ||= {}
    end

    def rooms
      @store["rooms"] ||= {}
    end

  end
end
