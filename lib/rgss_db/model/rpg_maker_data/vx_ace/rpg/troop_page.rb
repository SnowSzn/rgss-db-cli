# frozen_string_literal: true

module RPG
  #
  # The data class for enemy troops.
  #
  class Troop
    #
    # The data class for battle events (pages).
    #
    class Page
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @condition = RPG::Troop::Page::Condition.new
        @span = 0
        @list = [RPG::EventCommand.new]
      end

      attr_accessor :condition, :span, :list
    end
  end
end
