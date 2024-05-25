# frozen_string_literal: true

module RPG
  #
  # The data class for the system.
  #
  class System
    #
    # The data class for vehicles.
    #
    class Vehicle
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @character_name = ""
        @character_index = 0
        @bgm = RPG::BGM.new
        @start_map_id = 0
        @start_x = 0
        @start_y = 0
      end

      attr_accessor :character_name, :character_index, :bgm, :start_map_id, :start_x, :start_y
    end
  end
end
