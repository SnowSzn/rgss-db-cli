# frozen_string_literal: true

module RPG
  #
  # Data class for items.
  #
  class Item
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 0
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @price = 0
      @consumable = true
      @parameter_type = 0
      @parameter_points = 0
      @recover_hp_rate = 0
      @recover_hp = 0
      @recover_sp_rate = 0
      @recover_sp = 0
      @hit = 100
      @pdef_f = 0
      @mdef_f = 0
      @variance = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_name, :description, :scope, :occasion, :animation1_id, :animation2_id, :menu_se,
                  :common_event_id, :price, :consumable, :parameter_type, :parameter_points, :recover_hp_rate,
                  :recover_hp, :recover_sp_rate, :recover_sp, :hit, :pdef_f, :mdef_f, :variance, :element_set,
                  :plus_state_set, :minus_state_set
  end
end
