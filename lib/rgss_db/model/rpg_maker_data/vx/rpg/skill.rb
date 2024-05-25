# frozen_string_literal: true

module RPG
  #
  # Data class for skills.
  #
  class Skill < UsableItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @scope = 1
      @mp_cost = 0
      @hit = 100
      @message1 = ""
      @message2 = ""
    end

    attr_accessor :mp_cost, :hit, :message1, :message2
  end
end
