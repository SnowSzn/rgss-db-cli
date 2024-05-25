# frozen_string_literal: true

module RPG
  #
  # Data class for maps.
  #
  class Map
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(width, height)
      @width = width
      @height = height
      @scroll_type = 0
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @disable_dashing = false
      @encounter_list = []
      @encounter_step = 30
      @parallax_name = ""
      @parallax_loop_x = false
      @parallax_loop_y = false
      @parallax_sx = 0
      @parallax_sy = 0
      @parallax_show = false
      @data = Table.new(width, height, 3)
      @events = {}
    end

    #
    # JSON constructor
    #
    # @param args [Array]
    #
    # @return Class instance
    #
    def self.json_new(*args)
      new(-1, -1)
    end

    attr_accessor :width, :height, :scroll_type, :autoplay_bgm, :bgm, :autoplay_bgs, :bgs, :disable_dashing,
                  :encounter_list, :encounter_step, :parallax_name, :parallax_loop_x, :parallax_loop_y, :parallax_sx,
                  :parallax_sy, :parallax_show, :data, :events
  end
end
