# frozen_string_literal: true

module RPG
  #
  # Data class for areas.
  #
  class Area
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @map_id = 0
      @rect = Rect.new(0, 0, 0, 0)
      @encounter_list = []
      @order = 0
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :map_id, :rect, :encounter_list, :order
  end
end
