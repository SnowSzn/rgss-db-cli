# frozen_string_literal: true

module RPG
  #
  # Data class for animation.
  #
  class Animation
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @animation_name = ""
      @animation_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :animation_name, :animation_hue, :position, :frame_max, :frames, :timings
  end
end
