# frozen_string_literal: true

module RPG
  #
  # Data class for the Move route.
  #
  class MoveRoute
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @repeat = true
      @skippable = false
      @wait = false
      @list = [RPG::MoveCommand.new]
    end

    attr_accessor :repeat, :skippable, :wait, :list
  end
end
