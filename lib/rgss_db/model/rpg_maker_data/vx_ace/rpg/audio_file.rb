# frozen_string_literal: true

module RPG
  #
  # A superclass of BGM, BGS, ME, and SE.
  #
  class AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end

    def to_s
      @name.to_s
    end

    attr_accessor :name, :volume, :pitch
  end
end
