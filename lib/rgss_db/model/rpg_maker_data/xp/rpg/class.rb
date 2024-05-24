# frozen_string_literal: true

module RPG
  #
  # Data class for class.
  #
  class Class
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :position, :weapon_set, :armor_set, :element_ranks, :state_ranks, :learnings
  end
end
