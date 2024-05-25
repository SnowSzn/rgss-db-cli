# frozen_string_literal: true

module RPG
  #
  # The data class for enemies.
  #
  class Enemy < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @battler_name = ""
      @battler_hue = 0
      @params = [100, 0, 10, 10, 10, 10, 10, 10]
      @exp = 0
      @gold = 0
      @drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
      @actions = [RPG::Enemy::Action.new]
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
      @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
    end

    attr_accessor :battler_name, :battler_hue, :params, :exp, :gold, :drop_items, :actions
  end
end
