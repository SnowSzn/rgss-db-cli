# frozen_string_literal: true

module RPG
  #
  # Data class for weapons.
  #
  class Weapon < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @animation_id = 0
      @price = 0
      @hit = 95
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @two_handed = false
      @fast_attack = false
      @dual_attack = false
      @critical_bonus = false
      @element_set = []
      @state_set = []
    end

    attr_accessor :animation_id, :price, :hit, :atk, :def, :spi, :agi, :two_handed, :fast_attack, :dual_attack,
                  :critical_bonus, :element_set, :state_set
  end
end
