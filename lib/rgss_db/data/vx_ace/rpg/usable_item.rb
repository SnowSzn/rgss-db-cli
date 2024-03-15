# frozen_string_literal: true

module RPG
  #
  # The Superclass of Skill and Item.
  #
  class UsableItem < BaseItem
    #
    # The data inner class for damage.
    #
    class Damage
      def initialize
        @type = 0
        @element_id = 0
        @formula = "0"
        @variance = 20
        @critical = false
      end

      def as_json(*)
        { type: @type, element_id: @element_id, formula: @formula, variance: @variance, critical: @critical }
      end

      attr_accessor :type, :element_id, :formula, :variance, :critical
    end

    #
    # The data inner class for use effects.
    #
    class Effect
      def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
        @code = code
        @data_id = data_id
        @value1 = value1
        @value2 = value2
      end

      def as_json(*)
        { code: @code, data_id: @data_id, value1: @value1, value2: @value2 }
      end

      attr_accessor :code, :data_id, :value1, :value2
    end

    def initialize
      super
      @scope = 0
      @occasion = 0
      @speed = 0
      @success_rate = 100
      @repeats = 1
      @tp_gain = 0
      @hit_type = 0
      @animation_id = 0
      @damage = RPG::UsableItem::Damage.new
      @effects = []
    end

    def as_json(*)
      super.merge(
        {
          scope: @scope, occasion: @occasion, speed: @speed, success_rate: @success_rate, repeats: @repeats,
          tp_gain: @tp_gain, hit_type: @hit_type, animation_id: @animation_id,
          damage: @damage.as_json, effects: @effects.map(&:as_json)
        }
      )
    end

    attr_accessor :scope, :occasion, :speed, :animation_id, :success_rate,
                  :repeats, :tp_gain, :hit_type, :damage, :effects
  end
end
