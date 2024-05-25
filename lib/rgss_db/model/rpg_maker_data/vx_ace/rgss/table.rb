# frozen_string_literal: true

#
# The multidimensional array class.
#
# Each element is an integer of 2 signed bytes ranging from -32,768 to 32,767.
#
class Table
  include RgssDb::Jsonable
  extend RgssDb::JsonableConstructor

  #
  # Creates a Table object.
  #
  # Specifies the size of each dimension in the multidimensional array. 1-, 2-, and 3-dimensional arrays are possible.
  #
  # Arrays with no parameters are also permitted.
  #
  # @param xsize [Integer]
  # @param ysize [Integer]
  # @param zsize [Integer]
  #
  def initialize(xsize, ysize = 0, zsize = 0)
    # RMXP needs dimensions
    @dim = 1
    @dim = 2 if ysize.positive?
    @dim = 3 if zsize.positive?
    @x = xsize
    @y = ysize
    @z = zsize
    @data = []
  end

  #
  # Dumps this instance into a binary string
  #
  # Note: needed for Marshal module support
  #
  # @return [String]
  #
  def _dump(*)
    # int32_t, int32_t, int32_t, int32_t, int32_t, int16_t *
    [@dim, @x, @y, @z, @x * @y * @z, *@data].pack("llllls*")
  end

  #
  # Creates a new instance using the given binary data
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Table]
  #
  def self._load(serialized_string)
    Table.new_serialized(serialized_string)
  end

  #
  # Creates a new instance from a serialized string
  #
  # Note: needed for Marshal module support
  #
  # @param serialized_string [String]
  #
  # @return [Table]
  #
  def self.new_serialized(serialized_string)
    # int32_t, int32_t, int32_t, int32_t, int32_t, int16_t *
    dim, x, y, z, size, *data = serialized_string.unpack("llllls*")

    # Checks if written size value matches the actual size of the table
    raise "Table: bad file format (size mismatch)" unless size == (x * y * z)
    # Double check no data was lost
    raise "Table: bad file format (data length mismatch)" unless size == data.length

    # Creates the instance
    table = Table.new(0, 0, 0)
    table.dim = dim
    table.x = x
    table.y = y
    table.z = z
    table.data = data
    table
  end

  #
  # Returns a table instance for JSON deserialization
  #
  # @param args [Array]
  #
  # @return [Table]
  #
  def self.json_new(*args)
    Table.new(0, 0, 0)
  end

  attr_accessor :dim, :x, :y, :z, :data
end
