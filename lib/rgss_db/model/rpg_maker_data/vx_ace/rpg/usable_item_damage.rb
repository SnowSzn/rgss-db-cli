# frozen_string_literal: true

module RPG
  #
  # The Superclass of Skill and Item.
  #
  class UsableItem < BaseItem
    #
    # The data inner class for damage.
    #
    class Damage
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @type = 0
        @element_id = 0
        @formula = "0"
        @variance = 20
        @critical = false
      end

      def none?
        @type == 0
      end

      def to_hp?
        [1, 3, 5].include?(@type)
      end

      def to_mp?
        [2, 4, 6].include?(@type)
      end

      def recover?
        [3, 4].include?(@type)
      end

      def drain?
        [5, 6].include?(@type)
      end

      def sign
        recover? ? -1 : 1
      end

      def eval(a, b, v)
        [Kernel.eval(@formula), 0].max * sign
      rescue StandardError
        0
      end

      attr_accessor :type, :element_id, :formula, :variance, :critical
    end
  end
end
