# frozen_string_literal: true

module RPG
  #
  # Superclass of Skill and Item.
  #
  class UsableItem < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @animation_id = 0
      @common_event_id = 0
      @base_damage = 0
      @variance = 20
      @atk_f = 0
      @spi_f = 0
      @physical_attack = false
      @damage_to_mp = false
      @absorb_damage = false
      @ignore_defense = false
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end

    def for_opponent?
      [1, 2, 3, 4, 5, 6].include?(@scope)
    end

    def for_friend?
      [7, 8, 9, 10, 11].include?(@scope)
    end

    def for_dead_friend?
      [9, 10].include?(@scope)
    end

    def for_user?
      [11].include?(@scope)
    end

    def for_one?
      [1, 3, 4, 7, 9, 11].include?(@scope)
    end

    def for_two?
      [5].include?(@scope)
    end

    def for_three?
      [6].include?(@scope)
    end

    def for_random?
      [4, 5, 6].include?(@scope)
    end

    def for_all?
      [2, 8, 10].include?(@scope)
    end

    def dual?
      [3].include?(@scope)
    end

    def need_selection?
      [1, 3, 7, 9].include?(@scope)
    end

    def battle_ok?
      [0, 1].include?(@occasion)
    end

    def menu_ok?
      [0, 2].include?(@occasion)
    end

    attr_accessor :scope, :occasion, :speed, :animation_id, :common_event_id, :base_damage, :variance, :atk_f, :spi_f,
                  :physical_attack, :damage_to_mp, :absorb_damage, :ignore_defense, :element_set, :plus_state_set,
                  :minus_state_set
  end
end
