# frozen_string_literal: true

module RPG
  class Event
    class Page
      #
      # A database of event page conditions.
      #
      class Condition
        include RgssDb::Jsonable
        extend RgssDb::JsonableConstructor

        def initialize
          @switch1_valid = false
          @switch2_valid = false
          @variable_valid = false
          @self_switch_valid = false
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
        end

        attr_accessor :switch1_valid, :switch2_valid, :variable_valid, :self_switch_valid, :switch1_id, :switch2_id,
                      :variable_id, :variable_value, :self_switch_ch
      end
    end
  end
end
