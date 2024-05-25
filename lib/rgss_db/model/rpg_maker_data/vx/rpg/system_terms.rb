# frozen_string_literal: true

module RPG
  class System
    #
    # Data class for terminology.
    #
    class Terms
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @level = ""
        @level_a = ""
        @hp = ""
        @hp_a = ""
        @mp = ""
        @mp_a = ""
        @atk = ""
        @def = ""
        @spi = ""
        @agi = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @weapon1 = ""
        @weapon2 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
        @status = ""
        @save = ""
        @game_end = ""
        @fight = ""
        @escape = ""
        @new_game = ""
        @continue = ""
        @shutdown = ""
        @to_title = ""
        @cancel = ""
        @gold = ""
      end

      attr_accessor :level, :level_a, :hp, :hp_a, :mp, :mp_a, :atk, :def, :spi, :agi, :weapon, :armor1, :armor2,
                    :armor3, :armor4, :weapon1, :weapon2, :attack, :skill, :guard, :item, :equip, :status,
                    :save, :game_end, :fight, :escape, :new_game, :continue, :shutdown, :to_title, :cancel, :gold
    end
  end
end
