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
        @condition_type = 0
        @condition_param1 = 0
        @condition_param2 = 0
        @rating = 5
      end

      def skill?
        @kind == 1
      end

      attr_accessor :kind, :basic, :skill_id, :condition_type, :condition_param1, :condition_param2, :rating
    end
  end
end
