# frozen_string_literal: true

module RPG
  #
  # The data class for enemies.
  #
  class Enemy < BaseItem
    #
    # The data class for enemy [Actions].
    #
    class Action
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @skill_id = 1
        @condition_type = 0
        @condition_param1 = 0
        @condition_param2 = 0
        @rating = 5
      end

      attr_accessor :skill_id, :condition_type, :condition_param1, :condition_param2, :rating
    end
  end
end
