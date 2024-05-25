# frozen_string_literal: true

module RPG
  #
  # A superclass of weapons and armor.
  #
  class EquipItem < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @price = 0
      @etype_id = 0
      @params = [0] * 8
    end
    attr_accessor :price, :etype_id, :params
  end
end
