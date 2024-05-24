# frozen_string_literal: true

module RPG
  #
  # Data class for skills.
  #
  class Skill
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 1
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @sp_cost = 0
      @power = 0
      @atk_f = 0
      @eva_f = 0
      @str_f = 0
      @dex_f = 0
      @agi_f = 0
      @int_f = 100
      @hit = 100
      @pdef_f = 0
      @mdef_f = 100
      @variance = 15
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_name, :description, :scope, :occasion, :animation1_id, :animation2_id, :menu_se,
                  :common_event_id, :sp_cost, :power, :atk_f, :eva_f, :str_f, :dex_f, :agi_f, :int_f, :hit, :pdef_f,
                  :mdef_f, :variance, :element_set, :plus_state_set, :minus_state_set
  end
end
