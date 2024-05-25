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
      # The data class for the Event page [Graphics].
      #
      class Graphic
        include RgssDb::Jsonable
        extend RgssDb::JsonableConstructor

        def initialize
          @tile_id = 0
          @character_name = ""
          @character_index = 0
          @direction = 2
          @pattern = 0
        end

        attr_accessor :tile_id, :character_name, :character_index, :direction, :pattern
      end
    end
  end
end
