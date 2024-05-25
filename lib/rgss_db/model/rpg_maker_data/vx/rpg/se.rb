# frozen_string_literal: true

module RPG
  #
  # Data class for SE. This class has a method to play oneself with Audio module.
  #
  class SE < AudioFile
    include RgssDb::Jsonable
    extend RgssDb::JsonableConstructor

    def play
      return if @name.empty?

      Audio.se_play("Audio/SE/" + @name, @volume, @pitch)
    end

    def self.stop
      Audio.se_stop
    end
  end
end
