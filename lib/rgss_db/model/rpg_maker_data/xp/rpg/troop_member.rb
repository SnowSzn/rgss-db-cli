# frozen_string_literal: true

module RPG
  class Troop
    #
    # Data class for troop members.
    #
    class Member
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
        @immortal = false
      end

      attr_accessor :enemy_id, :x, :y, :hidden, :immortal
    end
  end
end
