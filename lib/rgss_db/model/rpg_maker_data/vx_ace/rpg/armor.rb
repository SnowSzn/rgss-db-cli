# frozen_string_literal: true

module RPG
  #
  # The data class for armor.
  #
  class Armor < EquipItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @atype_id = 0
      @etype_id = 1
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0))
    end

    attr_accessor :atype_id
  end
end
