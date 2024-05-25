# frozen_string_literal: true

module RPG
  #
  # The data class for maps.
  #
  class Map
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(width, height)
      @display_name = ""
      @tileset_id = 1
      @width = width
      @height = height
      @scroll_type = 0
      @specify_battleback = false
      @battleback_floor_name = ""
      @battleback_wall_name = ""
      @autoplay_bgm = false
      @bgm = RPG::BGM.new
      @autoplay_bgs = false
      @bgs = RPG::BGS.new("", 80)
      @disable_dashing = false
      @encounter_list = []
      @encounter_step = 30
      @parallax_name = ""
      @parallax_loop_x = false
      @parallax_loop_y = false
      @parallax_sx = 0
      @parallax_sy = 0
      @parallax_show = false
      @note = ""
      @data = Table.new(width, height, 4)
      @events = {}
    end

    def to_s
      @display_name.to_s
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

    attr_accessor :display_name, :tileset_id, :width, :height, :scroll_type, :specify_battleback, :battleback1_name,
                  :battleback2_name, :autoplay_bgm, :bgm, :autoplay_bgs, :bgs, :disable_dashing, :encounter_list,
                  :encounter_step, :parallax_name, :parallax_loop_x, :parallax_loop_y, :parallax_sx, :parallax_sy,
                  :parallax_show, :note, :data, :events
  end
end
