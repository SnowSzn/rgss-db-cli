# frozen_string_literal: true

module RPG
  #
  # The data class for maps.
  #
  class Map
    #
    # The data class for the encounter settings.
    #
    class Encounter
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @troop_id = 1
        @weight = 10
        @region_set = []
      end
      attr_accessor :troop_id, :weight, :region_set
    end
  end
end
