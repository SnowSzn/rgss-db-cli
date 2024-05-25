# frozen_string_literal: true

module RPG
  class Class
    #
    # Data class for a [Class's Learned] skills.
    #
    class Learning
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @level = 1
        @skill_id = 1
      end

      attr_accessor :level, :skill_id
    end
  end
end
