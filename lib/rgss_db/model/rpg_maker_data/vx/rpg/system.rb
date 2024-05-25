# frozen_string_literal: true

module RPG
  #
  # Data class for the system.
  #
  class System
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @game_title = ""
      @version_id = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @passages = Table.new(8192)
      @boat = RPG::System::Vehicle.new
      @ship = RPG::System::Vehicle.new
      @airship = RPG::System::Vehicle.new
      @title_bgm = RPG::BGM.new
      @battle_bgm = RPG::BGM.new
      @battle_end_me = RPG::ME.new
      @gameover_me = RPG::ME.new
      @sounds = []
      20.times { @sounds.push(RPG::AudioFile.new) }
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @terms = RPG::System::Terms.new
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end

    attr_accessor :game_title, :version_id, :party_members, :elements, :switches, :variables, :passages, :boat, :ship,
                  :airship, :title_bgm, :battle_bgm, :battle_end_me, :gameover_me, :sounds, :test_battlers,
                  :test_troop_id, :start_map_id, :start_x, :start_y, :terms, :battler_name, :battler_hue, :edit_map_id
  end
end
