# frozen_string_literal: true

module RPG
  #
  # The data class for the Event command.
  #
  class EventCommand
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(code = 0, indent = 0, parameters = [])
      @code = code
      @indent = indent
      @parameters = parameters
    end

    attr_accessor :code, :indent, :parameters
  end
end
