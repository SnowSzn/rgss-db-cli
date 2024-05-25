# frozen_string_literal: true

module RPG
  #
  # The data class for state.
  #
  class State < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @restriction = 0
      @priority = 50
      @remove_at_battle_end = false
      @remove_by_restriction = false
      @auto_removal_timing = 0
      @min_turns = 1
      @max_turns = 1
      @remove_by_damage = false
      @chance_by_damage = 100
      @remove_by_walking = false
      @steps_to_remove = 100
      @message1 = ""
      @message2 = ""
      @message3 = ""
      @message4 = ""
    end

    attr_accessor :restriction, :priority, :remove_at_battle_end, :remove_by_restriction, :auto_removal_timing,
                  :min_turns, :max_turns, :remove_by_damage, :chance_by_damage, :remove_by_walking,
                  :steps_to_remove, :message1, :message2, :message3, :message4
  end
end
