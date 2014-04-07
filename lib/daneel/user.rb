# encoding: UTF-8
module Daneel
  # Represents a generic user. Doesn't have a room, because multiple rooms can
  # contain the same user. The user's unique identifier is supplied by the
  # adapter, and only needs to be unique within the context of that adapter.
  class User
    attr_reader :id, :name
    attr_accessor :data, :initials, :short_name

    def initialize(id, name, data = nil)
      @id, @name, @data = id, name, data

      # First, try to get initials from the upper-case letters
      @initials = name.gsub(/\P{Upper}/,'')
      # If that fails, just go with the first letter of each word
      @initials = name.gsub(/(?<!^|\s)./,'') if @initials.empty?
      # Short name is just the bit up to the first space
      @short_name = name.match(/^(\S+)/)[0]
    end

    def names
      [name, short_name, initials]
    end

    def to_s
      [short_name, short_name.downcase, initials].sample
    end

  end
end
