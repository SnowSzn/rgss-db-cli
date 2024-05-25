# frozen_string_literal: true

module RPG
  #
  # The data class for weapons.
  #
  class Weapon < EquipItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @wtype_id = 0
      @animation_id = 0
      @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0))
    end

    def performance
      params[2] + params[4] + params.inject(0) { |r, v| r += v }
    end

    attr_accessor :wtype_id, :animation_id
  end
end
