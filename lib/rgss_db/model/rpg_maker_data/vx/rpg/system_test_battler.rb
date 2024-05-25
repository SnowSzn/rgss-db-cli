# frozen_string_literal: true

module RPG
  class System
    #
    # Data class for the battlers used in battle tests.
    #
    class TestBattler
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @actor_id = 1
        @level = 1
        @weapon_id = 0
        @armor1_id = 0
        @armor2_id = 0
        @armor3_id = 0
        @armor4_id = 0
      end

      attr_accessor :actor_id, :level, :weapon_id, :armor1_id, :armor2_id, :armor3_id, :armor4_id
    end
  end
end
