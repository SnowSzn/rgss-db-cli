# frozen_string_literal: true

#
# RPG classes module
#
module RPG
  #
  # A superclass of actor, class, skill, item, weapon, armor, enemy, and state.
  #
  # Some items are unnecessary depending on the type of data, but they are included for convenience sake.
  #
  class BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @description = ""
      @features = []
      @note = ""
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :icon_index, :description, :features, :note
  end
end
