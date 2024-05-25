# frozen_string_literal: true

module RPG
  #
  # The data class for map events.
  #
  class Event
    #
    # The data class for the event page.
    #
    class Page
      #
      # The data class for the event page conditions.
      #
      class Condition
        include RgssDb::Jsonable
        extend RgssDb::JsonableConstructor

        def initialize
          @switch1_valid = false
          @switch2_valid = false
          @variable_valid = false
          @self_switch_valid = false
          @item_valid = false
          @actor_valid = false
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
          @item_id = 1
          @actor_id = 1
        end

        attr_accessor :switch1_valid, :switch2_valid, :variable_valid, :self_switch_valid, :item_valid, :actor_valid,
                      :switch1_id, :switch2_id, :variable_id, :variable_value, :self_switch_ch, :item_id, :actor_id
      end
    end
  end
end
