# frozen_string_literal: true

module RPG
  #
  # Data class for maps.
  #
  class Map
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(width, height)
      @tileset_id = 1
      @width = width
      @height = height
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @encounter_list = []
      @encounter_step = 30
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

    attr_accessor :tileset_id, :width, :height, :autoplay_bgm, :bgm, :autoplay_bgs, :bgs, :encounter_list,
                  :encounter_step, :data, :events
  end
end
