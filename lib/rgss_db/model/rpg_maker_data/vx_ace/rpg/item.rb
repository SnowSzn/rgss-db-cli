# frozen_string_literal: true

module RPG
  #
  # The data class for items.
  #
  class Item < UsableItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @scope = 7
      @itype_id = 1
      @price = 0
      @consumable = true
    end

    def key_item?
      @itype_id == 2
    end

    attr_accessor :itype_id, :price, :consumable
  end
end
