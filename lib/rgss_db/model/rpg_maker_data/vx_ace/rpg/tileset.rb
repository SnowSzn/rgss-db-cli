# frozen_string_literal: true

module RPG
  #
  # The data class for tile sets.
  #
  class Tileset
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @mode = 1
      @name = ""
      @tileset_names = Array.new(9).collect { "" }
      @flags = Table.new(8192)
      @note = ""
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :mode, :name, :tileset_names, :flags, :note
  end
end
