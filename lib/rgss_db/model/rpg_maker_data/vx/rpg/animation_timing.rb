# frozen_string_literal: true

module RPG
  class Animation
    #
    # Data class for the timing of an animation's SE and flash effects.
    #
    class Timing
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @frame = 0
        @se = RPG::AudioFile.new("", 80)
        @flash_scope = 0
        @flash_color = Color.new(255, 255, 255, 255)
        @flash_duration = 5
      end

      attr_accessor :frame, :se, :flash_scope, :flash_color, :flash_duration
    end
  end
end
