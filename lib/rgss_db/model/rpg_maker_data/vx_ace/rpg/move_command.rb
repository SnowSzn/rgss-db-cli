# frozen_string_literal: true

module RPG
  #
  # The data class for the Move command.
  #
  class MoveCommand
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
    attr_accessor :code, :parameters
  end
end
