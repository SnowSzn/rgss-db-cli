# frozen_string_literal: true

module RPG
  #
  # The data class for skills.
  #
  class Skill < UsableItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @scope = 1
      @stype_id = 1
      @mp_cost = 0
      @tp_cost = 0
      @message1 = ""
      @message2 = ""
      @required_wtype_id1 = 0
      @required_wtype_id2 = 0
    end

    attr_accessor :stype_id, :mp_cost, :tp_cost, :message1, :message2, :required_wtype_id1, :required_wtype_id2
  end
end
