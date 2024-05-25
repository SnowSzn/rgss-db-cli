# frozen_string_literal: true

module RPG
  #
  # Superclass of Skill, Item, Weapon, and Armor.
  #
  class BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @description = ""
      @note = ""
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_index, :description, :note
  end
end
