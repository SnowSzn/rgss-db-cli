# frozen_string_literal: true

module RPG
  #
  # Data class for armor.
  #
  class Armor
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @kind = 0
      @auto_state_id = 0
      @price = 0
      @pdef = 0
      @mdef = 0
      @eva = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @guard_element_set = []
      @guard_state_set = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_name, :description, :kind, :auto_state_id, :price, :pdef, :mdef, :eva, :str_plus,
                  :dex_plus, :agi_plus, :int_plus, :guard_element_set, :guard_state_set
  end
end
