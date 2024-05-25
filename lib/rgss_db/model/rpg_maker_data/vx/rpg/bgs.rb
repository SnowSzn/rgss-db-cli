# frozen_string_literal: true

module RPG
  #
  # Data class for BGS. This class has a method to play oneself with Audio module.
  #
  class BGS < AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    @@last = BGS.new
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        Audio.bgs_play("Audio/BGS/" + @name, @volume, @pitch)
        @@last = self
      end
    end

    def self.stop
      Audio.bgs_stop
      @@last = BGS.new
    end

    def self.fade(time)
      Audio.bgs_fade(time)
      @@last = BGS.new
    end

    def self.last
      @@last
    end
  end
end
