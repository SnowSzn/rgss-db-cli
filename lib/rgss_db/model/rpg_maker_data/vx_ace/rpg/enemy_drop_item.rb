# frozen_string_literal: true

module RPG
  #
  # The data class for enemies.
  #
  class Enemy < BaseItem
    #
    # The data class for enemy [Drop Items].
    #
    class DropItem
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @kind = 0
        @data_id = 1
        @denominator = 1
      end

      attr_accessor :kind, :data_id, :denominator
    end
  end
end
