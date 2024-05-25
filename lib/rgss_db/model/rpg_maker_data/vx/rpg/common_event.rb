# frozen_string_literal: true

module RPG
  #
  # Data class for common events.
  #
  class CommonEvent
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @trigger = 0
      @switch_id = 1
      @list = [RPG::EventCommand.new]
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :trigger, :switch_id, :list
  end
end
