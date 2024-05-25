# frozen_string_literal: true

module RPG
  #
  # The data class for actors.
  #
  class Actor < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @nickname = ""
      @class_id = 1
      @initial_level = 1
      @max_level = 99
      @character_name = ""
      @character_index = 0
      @face_name = ""
      @face_index = 0
      @equips = [0, 0, 0, 0, 0]
    end

    attr_accessor :nickname, :class_id, :initial_level, :max_level, :character_name, :character_index, :face_name,
                  :face_index, :equips
  end
end
