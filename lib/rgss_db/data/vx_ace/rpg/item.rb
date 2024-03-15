# frozen_string_literal: true

module RPG
  #
  # The data class for items.
  #
  class Item < UsableItem
    def initialize
      super
      @scope = 7
      @itype_id = 1
      @price = 0
      @consumable = true
    end

    def as_json(*)
      super.merge(
        {
          itype_id: @itype_id, price: @price, consumable: @consumable
        }
      )
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

    attr_accessor :itype_id, :price, :consumable
  end
end
