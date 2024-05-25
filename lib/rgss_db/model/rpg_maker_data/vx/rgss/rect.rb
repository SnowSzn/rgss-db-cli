# frozen_string_literal: true

#
# The rectangle class.
#
class Rect
  include RgssDb::Jsonable
  extend RgssDb::JsonableConstructor

  #
  # Creates a new Rect object.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).
  #
  # @param x [Integer]
  # @param y [Integer]
  # @param width [Integer]
  # @param height [Integer]
  #
  def initialize(x = 0, y = 0, width = 0, height = 0)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  #
  # Dumps this instance into a binary string
  #
  # Note: needed for Marshal module support
  #
  # @return [String]
  #
  def _dump(*)
    # int32_t, int32_t, int32_t, int32_t
    [@x, @y, @width, @height].pack("llll")
  end

  #
  # Creates a new instance using the given binary data
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Rect]
  #
  def self._load(serialized_string)
    Rect.new_serialized(serialized_string)
  end

  #
  # Creates a new instance from a serialized string
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Rect]
  #
  def self.new_serialized(serialized_string)
    # int32_t, int32_t, int32_t, int32_t
    x, y, width, height = serialized_string.unpack("llll")

    # Creates the instance
    Rect.new(x, y, width, height)
  end

  attr_accessor :x, :y, :width, :height
end
