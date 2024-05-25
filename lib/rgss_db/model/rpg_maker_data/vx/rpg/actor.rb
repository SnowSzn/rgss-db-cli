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
      @exp_basis = 25
      @exp_inflation = 35
      @character_name = ""
      @character_index = 0
      @face_name = ""
      @face_index = 0
      @parameters = Table.new(6, 100)
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @two_swords_style = false
      @fix_equipment = false
      @auto_battle = false
      @super_guard = false
      @pharmacology = false
      @critical_bonus = false
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :class_id, :initial_level, :exp_basis, :exp_inflation, :character_name, :character_index,
                  :face_name, :face_index, :parameters, :weapon_id, :armor1_id, :armor2_id, :armor3_id, :armor4_id,
                  :two_swords_style, :fix_equipment, :auto_battle, :super_guard, :pharmacology, :critical_bonus
  end
end
