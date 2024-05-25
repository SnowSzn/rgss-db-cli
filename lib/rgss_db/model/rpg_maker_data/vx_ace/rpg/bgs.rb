# frozen_string_literal: true

module RPG
  #
  # The data class for BGS. This class has functionality for playing itself using an Audio module.
  #
  class BGS < AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    @@last = RPG::BGS.new
    def play(pos = 0)
      if @name.empty?
        Audio.bgs_stop
        @@last = RPG::BGS.new
      else
        Audio.bgs_play("Audio/BGS/" + @name, @volume, @pitch, pos)
        @@last = clone
      end
    end

    def replay
      play(@pos)
    end

    def self.stop
      Audio.bgs_stop
      @@last = RPG::BGS.new
    end

    def self.fade(time)
      Audio.bgs_fade(time)
      @@last = RPG::BGS.new
    end

    def self.last
      @@last.pos = Audio.bgs_pos
      @@last
    end

    attr_accessor :pos
  end
end
