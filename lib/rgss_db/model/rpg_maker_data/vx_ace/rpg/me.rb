# frozen_string_literal: true

module RPG
  #
  # The data class for ME. This class has functionality for playing itself using an Audio module.
  #
  class ME < AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def play
      if @name.empty?
        Audio.me_stop
      else
        Audio.me_play("Audio/ME/" + @name, @volume, @pitch)
      end
    end

    def self.stop
      Audio.me_stop
    end

    def self.fade(time)
      Audio.me_fade(time)
    end
  end
end
