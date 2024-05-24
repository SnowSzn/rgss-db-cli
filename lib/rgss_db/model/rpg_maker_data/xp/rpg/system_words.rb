# frozen_string_literal: true

module RPG
  class System
    #
    # Data class for terminology.
    #
    class Words
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @gold = ""
        @hp = ""
        @sp = ""
        @str = ""
        @dex = ""
        @agi = ""
        @int = ""
        @atk = ""
        @pdef = ""
        @mdef = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
      end

      attr_accessor :gold, :hp, :sp, :str, :dex, :agi, :int, :atk, :pdef, :mdef, :weapon, :armor1, :armor2, :armor3,
                    :armor4, :attack, :skill, :guard, :item, :equip
    end
  end
end
