# frozen_string_literal: true

module RPG
  #
  # The data class for the system.
  #
  class System
    #
    # The data class for terminology.
    #
    class Terms
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @basic = Array.new(8) { "" }
        @params = Array.new(8) { "" }
        @etypes = Array.new(5) { "" }
        @commands = Array.new(23) { "" }
      end

      attr_accessor :basic, :params, :etypes, :commands
    end
  end
end
