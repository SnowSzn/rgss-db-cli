# frozen_string_literal: true

module RPG
  #
  # Data class for items.
  #
  class Item < UsableItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @scope = 7
      @price = 0
      @consumable = true
      @hp_recovery_rate = 0
      @hp_recovery = 0
      @mp_recovery_rate = 0
      @mp_recovery = 0
      @parameter_type = 0
      @parameter_points = 0
    end

    attr_accessor :price, :consumable, :hp_recovery_rate, :hp_recovery, :mp_recovery_rate, :mp_recovery,
                  :parameter_type, :parameter_points
  end
end
