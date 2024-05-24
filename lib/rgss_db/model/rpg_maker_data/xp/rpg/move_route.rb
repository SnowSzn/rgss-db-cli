# frozen_string_literal: true

module RPG
  #
  # Data class for the move route (movement route).
  #
  class MoveRoute
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @repeat = true
      @skippable = false
      @list = [RPG::MoveCommand.new]
    end

    attr_accessor :repeat, :skippable, :list
  end
end
