# frozen_string_literal: true

module RPG
  #
  # Data class for tilesets.
  #
  class Tileset
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @tileset_name = ""
      @autotile_names = [""] * 7
      @panorama_name = ""
      @panorama_hue = 0
      @fog_name = ""
      @fog_hue = 0
      @fog_opacity = 64
      @fog_blend_type = 0
      @fog_zoom = 200
      @fog_sx = 0
      @fog_sy = 0
      @battleback_name = ""
      @passages = Table.new(384)
      @priorities = Table.new(384)
      @terrain_tags = Table.new(384)
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :tileset_name, :autotile_names, :panorama_name, :panorama_hue, :fog_name, :fog_hue,
                  :fog_opacity, :fog_blend_type, :fog_zoom, :fog_sx, :fog_sy, :battleback_name, :passages,
                  :priorities, :terrain_tags
  end
end
