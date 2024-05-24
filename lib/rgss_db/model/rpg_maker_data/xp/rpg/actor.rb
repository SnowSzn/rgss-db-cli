# frozen_string_literal: true

module RPG
  #
  # Data class for actors.
  #
  class Actor
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @final_level = 99
      @exp_basis = 30
      @exp_inflation = 30
      @character_name = ""
      @character_hue = 0
      @battler_name = ""
      @battler_hue = 0
      @parameters = Table.new(6, 100)
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @weapon_fix = false
      @armor1_fix = false
      @armor2_fix = false
      @armor3_fix = false
      @armor4_fix = false
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :class_id, :initial_level, :final_level, :exp_basis, :exp_inflation, :character_name,
                  :character_hue, :battler_name, :battler_hue, :parameters, :weapon_id, :armor1_id, :armor2_id,
                  :armor3_id, :armor4_id, :weapon_fix, :armor1_fix, :armor2_fix, :armor3_fix, :armor4_fix
  end
end
