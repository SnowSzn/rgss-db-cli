# frozen_string_literal: true

module RPG
  class Enemy
    #
    # Data class for enemy [Actions].
    #
    class Action
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_turn_a = 0
        @condition_turn_b = 1
        @condition_hp = 100
        @condition_level = 1
        @condition_switch_id = 0
        @rating = 5
      end

      attr_accessor :kind, :basic, :skill_id, :condition_turn_a, :condition_turn_b, :condition_hp, :condition_level,
                    :condition_switch_id, :rating
    end
  end
end
