# frozen_string_literal: true

module RPG
  #
  # Data class for state.
  #
  class State
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @animation_id = 0
      @restriction = 0
      @nonresistance = false
      @zero_hp = false
      @cant_get_exp = false
      @cant_evade = false
      @slip_damage = false
      @rating = 5
      @hit_rate = 100
      @maxhp_rate = 100
      @maxsp_rate = 100
      @str_rate = 100
      @dex_rate = 100
      @agi_rate = 100
      @int_rate = 100
      @atk_rate = 100
      @pdef_rate = 100
      @mdef_rate = 100
      @eva = 0
      @battle_only = true
      @hold_turn = 0
      @auto_release_prob = 0
      @shock_release_prob = 0
      @guard_element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :animation_id, :restriction, :nonresistance, :zero_hp, :cant_get_exp, :cant_evade,
                  :slip_damage, :rating, :hit_rate, :maxhp_rate, :maxsp_rate, :str_rate, :dex_rate, :agi_rate,
                  :int_rate, :atk_rate, :pdef_rate, :mdef_rate, :eva, :battle_only, :hold_turn, :auto_release_prob,
                  :shock_release_prob, :guard_element_set, :plus_state_set, :minus_state_set
  end
end
