# frozen_string_literal: true

#
# The RGBA color class.
#
# Each component is handled with a floating-point value (Float).
#
class Color
  include RgssDb::Jsonable
  extend RgssDb::JsonableConstructor

  #
  # Creates a Color object. If alpha is omitted, it is assumed to be 255.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).
  #
  # @param red [Integer]
  # @param green [Integer]
  # @param blue [Integer]
  # @param alpha [Integer]
  #
  def initialize(red = 0, green = 0, blue = 0, alpha = 0)
    @red = red
    @green = green
    @blue = blue
    @alpha = [red, green, blue].sum.positive? && alpha.zero? ? 255 : alpha
  end

  #
  # Dumps this instance into a binary string
  #
  # Note: needed for Marshal module support
  #
  # @return [String]
  #
  def _dump(*)
    # double, double, double, double (double-precision)
    [@red, @green, @blue, @alpha].pack("dddd")
  end

  #
  # Creates a new instance using the given binary data
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Color]
  #
  def self._load(serialized_string)
    Color.new_serialized(serialized_string)
  end

  #
  # Creates a new instance from a serialized string
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Color]
  #
  def self.new_serialized(serialized_string)
    # double, double, double, double (double-precision)
    red, green, blue, alpha = serialized_string.unpack("dddd")

    # Creates the instance
    Color.new(red, green, blue, alpha)
  end

  attr_accessor :red, :green, :blue, :alpha
end
