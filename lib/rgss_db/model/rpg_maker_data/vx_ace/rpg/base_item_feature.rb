# frozen_string_literal: true

#
# RPG classes module
#
module RPG
  #
  # A superclass of actor, class, skill, item, weapon, armor, enemy, and state.
  #
  # Some items are unnecessary depending on the type of data, but they are included for convenience sake.
  #
  class BaseItem
    #
    # The data inner class for features.
    #
    class Feature
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize(code = 0, data_id = 0, value = 0)
        @code = code
        @data_id = data_id
        @value = value
      end

      attr_accessor :code, :data_id, :value
    end
  end
end
