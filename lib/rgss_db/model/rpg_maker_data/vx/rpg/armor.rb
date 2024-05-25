# frozen_string_literal: true

module RPG
  #
  # Data class for armor.
  #
  class Armor < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @kind = 0
      @price = 0
      @eva = 0
      @atk = 0
      @def = 0
      @spi = 0
      @agi = 0
      @prevent_critical = false
      @half_mp_cost = false
      @double_exp_gain = false
      @auto_hp_recover = false
      @element_set = []
      @state_set = []
    end

    attr_accessor :kind, :price, :eva, :atk, :def, :spi, :agi, :prevent_critical, :half_mp_cost, :double_exp_gain,
                  :auto_hp_recover, :element_set, :state_set
  end
end
