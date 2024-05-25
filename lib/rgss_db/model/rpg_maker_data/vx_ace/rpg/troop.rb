# frozen_string_literal: true

module RPG
  #
  # The data class for enemy troops.
  #
  class Troop
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize
      @id = 0
      @name = ""
      @members = []
      @pages = [RPG::Troop::Page.new]
    end

    def to_s
      @name.to_s
    end

    attr_accessor :id, :name, :members, :pages
  end
end
