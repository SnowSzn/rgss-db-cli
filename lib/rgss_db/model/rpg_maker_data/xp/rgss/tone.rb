# frozen_string_literal: true

#
# The color tone class.
#
# Each component is handled with a floating-point value (Float).
#
class Tone
  include RgssDb::Jsonable
  extend RgssDb::JsonableConstructor

  #
  # Creates a Tone object. If gray is omitted, it is assumed to be 0.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).
  #
  # @param red [Integer]
  # @param green [Integer]
  # @param blue [Integer]
  # @param gray [Integer]
  #
  def initialize(red = 0, green = 0, blue = 0, gray = 0)
    @red = red
    @green = green
    @blue = blue
    @gray = gray
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
    [@red, @green, @blue, @gray].pack("dddd")
  end

  #
  # Creates a new instance using the given binary data
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Tone]
  #
  def self._load(serialized_string)
    Tone.new_serialized(serialized_string)
  end

  #
  # Creates a new instance from a serialized string
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Tone]
  #
  def self.new_serialized(serialized_string)
    # double, double, double, double (double-precision)
    red, green, blue, gray = serialized_string.unpack("dddd")

    # Creates the instance
    Tone.new(red, green, blue, gray)
  end

  attr_accessor :red, :green, :blue, :gray
end
