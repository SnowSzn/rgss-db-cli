# frozen_string_literal: true

module RPG
  #
  # Data class for weapons.
  #
  class Weapon
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @animation1_id = 0
      @animation2_id = 0
      @price = 0
      @atk = 0
      @pdef = 0
      @mdef = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_name, :description, :animation1_id, :animation2_id, :price, :atk, :pdef, :mdef,
                  :str_plus, :dex_plus, :agi_plus, :int_plus, :element_set, :plus_state_set, :minus_state_set
  end
end
