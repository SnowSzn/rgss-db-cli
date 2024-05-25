# frozen_string_literal: true

module RPG
  #
  # The data class for animation.
  #
  class Animation
    #
    # The data class for animation frames.
    #
    class Frame
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @cell_max = 0
        @cell_data = Table.new(0, 0)
      end

      attr_accessor :cell_max, :cell_data
    end
  end
end
