# frozen_string_literal: true

module RPG
  #
  # The Superclass of Skill and Item.
  #
  class UsableItem < BaseItem
    #
    # The data inner class for use effects.
    #
    class Effect
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
        @code = code
        @data_id = data_id
        @value1 = value1
        @value2 = value2
      end

      attr_accessor :code, :data_id, :value1, :value2
    end
  end
end
