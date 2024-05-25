# frozen_string_literal: true

module RPG
  #
  # Data class for BGM. This class has a method to play oneself with Audio module.
  #
  class BGM < AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    @@last = BGM.new
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        Audio.bgm_play("Audio/BGM/" + @name, @volume, @pitch)
        @@last = self
      end
    end

    def self.stop
      Audio.bgm_stop
      @@last = BGM.new
    end

    def self.fade(time)
      Audio.bgm_fade(time)
      @@last = BGM.new
    end

    def self.last
      @@last
    end
  end
end
