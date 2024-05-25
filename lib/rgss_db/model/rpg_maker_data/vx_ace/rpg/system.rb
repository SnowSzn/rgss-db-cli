# frozen_string_literal: true

module RPG
  #
  # The data class for the system.
  #
  class System
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @game_title = ""
      @version_id = 0
      @japanese = true
      @party_members = [1]
      @currency_unit = ""
      @elements = [nil, ""]
      @skill_types = [nil, ""]
      @weapon_types = [nil, ""]
      @armor_types = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @boat = RPG::System::Vehicle.new
      @ship = RPG::System::Vehicle.new
      @airship = RPG::System::Vehicle.new
      @title1_name = ""
      @title2_name = ""
      @opt_draw_title = true
      @opt_use_midi = false
      @opt_transparent = false
      @opt_followers = true
      @opt_slip_death = false
      @opt_floor_death = false
      @opt_display_tp = true
      @opt_extra_exp = false
      @window_tone = Tone.new(0, 0, 0)
      @title_bgm = RPG::BGM.new
      @battle_bgm = RPG::BGM.new
      @battle_end_me = RPG::ME.new
      @gameover_me = RPG::ME.new
      @sounds = Array.new(24) { RPG::SE.new }
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @terms = RPG::System::Terms.new
      @battleback1_name = ""
      @battleback2_name = ""
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    attr_accessor :game_title, :version_id, :japanese, :party_members, :currency_unit, :skill_types, :weapon_types,
                  :armor_types, :elements, :switches, :variables, :boat, :ship, :airship, :title1_name, :title2_name,
                  :opt_draw_title, :opt_use_midi, :opt_transparent, :opt_followers, :opt_slip_death, :opt_floor_death,
                  :opt_display_tp, :opt_extra_exp, :window_tone, :title_bgm, :battle_bgm, :battle_end_me,
                  :gameover_me, :sounds, :test_battlers, :test_troop_id, :start_map_id, :start_x, :start_y,
                  :terms, :battleback1_name, :battleback2_name, :battler_name, :battler_hue, :edit_map_id
  end
end
