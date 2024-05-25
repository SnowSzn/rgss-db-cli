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
      @maxhp = 10
      @maxmp = 10
      @atk = 10
      @def = 10
      @spi = 10
      @agi = 10
      @hit = 95
      @eva = 5
      @exp = 0
      @gold = 0
      @drop_item1 = RPG::Enemy::DropItem.new
      @drop_item2 = RPG::Enemy::DropItem.new
      @levitate = false
      @has_critical = false
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @note = ""
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :battler_name, :battler_hue, :maxhp, :maxmp, :atk, :def, :spi, :agi, :hit, :eva, :exp,
                  :gold, :drop_item1, :drop_item2, :levitate, :has_critical, :element_ranks, :state_ranks,
                  :actions, :note
  end
end
