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
      @icon_index = 0
      @restriction = 0
      @priority = 5
      @atk_rate = 100
      @def_rate = 100
      @spi_rate = 100
      @agi_rate = 100
      @nonresistance = false
      @offset_by_opposite = false
      @slip_damage = false
      @reduce_hit_ratio = false
      @battle_only = true
      @release_by_damage = false
      @hold_turn = 0
      @auto_release_prob = 0
      @message1 = ""
      @message2 = ""
      @message3 = ""
      @message4 = ""
      @element_set = []
      @state_set = []
      @note = ""
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_index, :restriction, :priority, :atk_rate, :def_rate, :spi_rate, :agi_rate,
                  :nonresistance, :offset_by_opposite, :slip_damage, :reduce_hit_ratio, :battle_only,
                  :release_by_damage, :hold_turn, :auto_release_prob, :message1, :message2,
                  :message3, :message4, :element_set, :state_set, :note
  end
end
