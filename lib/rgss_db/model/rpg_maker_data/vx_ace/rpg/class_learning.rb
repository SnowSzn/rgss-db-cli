# frozen_string_literal: true

module RPG
  #
  # The data class for class.
  #
  class Class < BaseItem
    #
    # The data class for a class's [Skills to Learn].
    #
    class Learning
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @level = 1
        @skill_id = 1
        @note = ""
      end

      attr_accessor :level, :skill_id, :note
    end
  end
end
