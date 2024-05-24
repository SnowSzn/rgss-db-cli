# frozen_string_literal: true

module RPG
  #
  # Data class for the system.
  #
  class System
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @magic_number = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @windowskin_name = ""
      @title_name = ""
      @gameover_name = ""
      @battle_transition = ""
      @title_bgm = RPG::AudioFile.new
      @battle_bgm = RPG::AudioFile.new
      @battle_end_me = RPG::AudioFile.new
      @gameover_me = RPG::AudioFile.new
      @cursor_se = RPG::AudioFile.new("", 80)
      @decision_se = RPG::AudioFile.new("", 80)
      @cancel_se = RPG::AudioFile.new("", 80)
      @buzzer_se = RPG::AudioFile.new("", 80)
      @equip_se = RPG::AudioFile.new("", 80)
      @shop_se = RPG::AudioFile.new("", 80)
      @save_se = RPG::AudioFile.new("", 80)
      @load_se = RPG::AudioFile.new("", 80)
      @battle_start_se = RPG::AudioFile.new("", 80)
      @escape_se = RPG::AudioFile.new("", 80)
      @actor_collapse_se = RPG::AudioFile.new("", 80)
      @enemy_collapse_se = RPG::AudioFile.new("", 80)
      @words = RPG::System::Words.new
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @battleback_name = ""
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    attr_accessor :magic_number, :party_members, :elements, :switches, :variables, :windowskin_name, :title_name,
                  :gameover_name, :battle_transition, :title_bgm, :battle_bgm, :battle_end_me, :gameover_me,
                  :cursor_se, :decision_se, :cancel_se, :buzzer_se, :equip_se, :shop_se, :save_se, :load_se,
                  :battle_start_se, :escape_se, :actor_collapse_se, :enemy_collapse_se, :words, :test_battlers,
                  :test_troop_id, :start_map_id, :start_x, :start_y, :battleback_name, :battler_name,
                  :battler_hue, :edit_map_id
  end
end
