# frozen_string_literal: true

module RPG
  #
  # The data class for the system.
  #
  class System
    #
    # The data class for the actors used in battle tests.
    #
    class TestBattler
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @actor_id = 1
        @level = 1
        @equips = [0, 0, 0, 0, 0]
      end

      attr_accessor :actor_id, :level, :equips
    end
  end
end
