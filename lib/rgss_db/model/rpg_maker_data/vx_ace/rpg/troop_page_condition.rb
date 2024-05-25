# frozen_string_literal: true

module RPG
  #
  # The data class for enemy troops.
  #
  class Troop
    #
    # The data class for battle events (pages).
    #
    class Page
      #
      # The data class of battle event [Conditions].
      #
      class Condition
        include RgssDb::Jsonable
        extend RgssDb::JsonableConstructor

        def initialize
          @turn_ending = false
          @turn_valid = false
          @enemy_valid = false
          @actor_valid = false
          @switch_valid = false
          @turn_a = 0
          @turn_b = 0
          @enemy_index = 0
          @enemy_hp = 50
          @actor_id = 1
          @actor_hp = 50
          @switch_id = 1
        end

        attr_accessor :turn_ending, :turn_valid, :enemy_valid, :actor_valid, :switch_valid,
                      :turn_a, :turn_b, :enemy_index, :enemy_hp, :actor_id, :actor_hp, :switch_id
      end
    end
  end
end
