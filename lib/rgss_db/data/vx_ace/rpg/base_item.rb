# frozen_string_literal: true

#
# RPG classes module
#
module RPG
  #
  # A superclass of actor, class, skill, item, weapon, armor, enemy, and state.
  #
  # Some items are unnecessary depending on the type of data, but they are included for convenience sake.
  #
  class BaseItem
    #
    # The data inner class for features.
    #
    class Feature
      def initialize(code = 0, data_id = 0, value = 0)
        @code = code
        @data_id = data_id
        @value = value
      end

      def as_json(*)
        { code: @code, data_id: @data_id, value: @value }
      end

      attr_accessor :code, :data_id, :value
    end

    def initialize
      @id = 0
      @name = ""
      @icon_index = 0
      @description = ""
      @features = []
      @note = ""
    end

    def as_json(*)
      {
        id: @id, name: @name, icon_index: @icon_index,
        description: @description, features: @features.map(&:as_json), note: @note
      }
    end

    attr_accessor :id, :name, :icon_index, :description, :features, :note
  end
end
