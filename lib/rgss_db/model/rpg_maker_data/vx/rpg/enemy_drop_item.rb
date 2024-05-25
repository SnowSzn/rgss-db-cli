# frozen_string_literal: true

module RPG
  class Enemy
    #
    # Data class for enemy [Drop Item].
    #
    class DropItem
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @kind = 0
        @item_id = 1
        @weapon_id = 1
        @armor_id = 1
        @denominator = 1
      end

      attr_accessor :kind, :item_id, :weapon_id, :armor_id, :denominator
    end
  end
end
