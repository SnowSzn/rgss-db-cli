# frozen_string_literal: true

module RPG
  #
  # The data class for class.
  #
  class Class < BaseItem
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      super
      @exp_params = [30, 20, 30, 30]
      @params = Table.new(8, 100)
      @learnings = []
      @features.push(RPG::BaseItem::Feature.new(23, 0, 1))
      @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
      @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
      @features.push(RPG::BaseItem::Feature.new(22, 2, 0.04))
      @features.push(RPG::BaseItem::Feature.new(41, 1))
      @features.push(RPG::BaseItem::Feature.new(51, 1))
      @features.push(RPG::BaseItem::Feature.new(52, 1))
    end

    def exp_for_level(level)
      lv = level.to_f
      basis = @exp_params[0].to_f
      extra = @exp_params[1].to_f
      acc_a = @exp_params[2].to_f
      acc_b = @exp_params[3].to_f
      (basis * ((lv - 1)**(0.9 + acc_a / 250)) * lv * (lv + 1) / (6 + lv**2 / 50 / acc_b) + (lv - 1) * extra)
        .round.to_i
    end

    attr_accessor :exp_params, :params, :learnings
  end
end
