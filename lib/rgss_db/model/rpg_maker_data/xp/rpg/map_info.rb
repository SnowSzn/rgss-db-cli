# frozen_string_literal: true

module RPG
  #
  # Data class for map information.
  #
  class MapInfo
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @name = ""
      @parent_id = 0
      @order = 0
      @expanded = false
      @scroll_x = 0
      @scroll_y = 0
    end

    def to_s
      @name.to_s
    end

    attr_accessor :name, :parent_id, :order, :expanded, :scroll_x, :scroll_y
  end
end
