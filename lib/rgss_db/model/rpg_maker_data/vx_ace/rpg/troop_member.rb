# frozen_string_literal: true

module RPG
  #
  # The data class for enemy troops.
  #
  class Troop
    #
    # The data class for enemy troop members.
    #
    class Member
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
      end

      attr_accessor :enemy_id, :x, :y, :hidden
    end
  end
end
