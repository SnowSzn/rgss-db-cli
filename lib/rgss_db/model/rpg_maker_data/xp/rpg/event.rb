# frozen_string_literal: true

module RPG
  #
  # Data class for map events.
  #
  class Event
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(x, y)
      @id = 0
      @name = ""
      @x = x
      @y = y
      @pages = [RPG::Event::Page.new]
    end

    def to_s
      @name.to_s
    end

    #
    # JSON constructor
    #
    # @param args [Array]
    #
    # @return Class instance
    #
    def self.json_new(*args)
      new(-1, -1)
    end

    attr_accessor :id, :name, :x, :y, :pages
  end
end
