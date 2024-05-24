# frozen_string_literal: true

module RPG
  class Event
    class Page
      #
      # Data class for the Event page [Graphics].
      #
      class Graphic
        include RgssDb::Jsonable
        extend RgssDb::JsonableConstructor

        def initialize
          @tile_id = 0
          @character_name = ""
          @character_hue = 0
          @direction = 2
          @pattern = 0
          @opacity = 255
          @blend_type = 0
        end

        attr_accessor :tile_id, :character_name, :character_hue, :direction, :pattern, :opacity, :blend_type
      end
    end
  end
end
