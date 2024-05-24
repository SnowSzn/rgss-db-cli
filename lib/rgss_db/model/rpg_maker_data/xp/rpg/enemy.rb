# frozen_string_literal: true

module RPG
  #
  # Data class for enemies.
  #
  class Enemy
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 500
      @maxsp = 500
      @str = 50
      @dex = 50
      @agi = 50
      @int = 50
      @atk = 100
      @pdef = 100
      @mdef = 100
      @eva = 0
      @animation1_id = 0
      @animation2_id = 0
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @exp = 0
      @gold = 0
      @item_id = 0
      @weapon_id = 0
      @armor_id = 0
      @treasure_prob = 100
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :battler_name, :battler_hue, :maxhp, :maxsp, :str, :dex, :agi, :int, :atk, :pdef, :mdef,
                  :eva, :animation1_id, :animation2_id, :element_ranks, :state_ranks, :actions, :exp, :gold, :item_id,
                  :weapon_id, :armor_id, :treasure_prob
  end
end
