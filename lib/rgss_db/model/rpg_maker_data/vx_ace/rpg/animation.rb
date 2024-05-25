# frozen_string_literal: true

module RPG
  #
  # The data class for animation.
  #
  class Animation
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @animation1_name = ""
      @animation1_hue = 0
      @animation2_name = ""
      @animation2_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :animation1_name, :animation1_hue, :animation2_name,
                  :animation2_hue, :position, :frame_max, :frames, :timings
  end
end
