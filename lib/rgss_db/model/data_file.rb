# frozen_string_literal: true

module RgssDb
  # Label used for data files that allows objects selection
  DATA_FILE_CUSTOM_LABEL = "_custom"

  # RPG Maker actors data file
  DATA_FILE_ACTORS = "Actors"

  # RPG Maker animations data file
  DATA_FILE_ANIMATIONS = "Animations"

  # RPG Maker areas data file
  DATA_FILE_AREAS = "Areas"

  # RPG Maker armors data file
  DATA_FILE_ARMORS = "Armors"

  # RPG Maker classes data file
  DATA_FILE_CLASSES = "Classes"

  # RPG Maker common events data file
  DATA_FILE_COMMON_EVENTS = "CommonEvents"

  # RPG Maker enemies data file
  DATA_FILE_ENEMIES = "Enemies"

  # RPG Maker items data file
  DATA_FILE_ITEMS = "Items"

  # RPG Maker maps data file
  DATA_FILE_MAPS = "Map[0-9][0-9][1-9]"

  # RPG Maker map infos data file
  DATA_FILE_MAP_INFOS = "MapInfos"

  # RPG Maker skills data file
  DATA_FILE_SKILLS = "Skills"

  # RPG Maker states data file
  DATA_FILE_STATES = "States"

  # RPG Maker system data file
  DATA_FILE_SYSTEM = "System"

  # RPG Maker tilesets data file
  DATA_FILE_TILESETS = "Tilesets"

  # RPG Maker troops data file
  DATA_FILE_TROOPS = "Troops"

  # RPG Maker weapons data file
  DATA_FILE_WEAPONS = "Weapons"

  #
  # RPG Maker base data file
  #
  # This class saves the object as is, without any treatment
  #
  class DataFile
    include Comparable

    # Data file path
    # @return [String]
    attr_reader :file_path

    # Data file object IDs list
    # @return [Array<Integer>]
    attr_reader :object_ids

    # Data file object (not processed)
    # @return [Object]
    attr_reader :object

    #
    # Constructor
    #
    # @param file_path [String] Data file path
    # @param object [Object] Data file object
    #
    def initialize(file_path, object)
      @file_path = file_path
      @object = object
      @object_ids = []
    end

    #
    # Checks if the given file matches this data file path
    #
    # The check is case insensitive
    #
    # @param [String] file File path
    #
    # @return [Boolean]
    #
    def file_path?(file)
      @file_path.casecmp?(file)
    end

    #
    # Checks if the given file base name matches this data file base name
    #
    # The check is case insensitive
    #
    # @param file [String] File path
    #
    # @return [Boolean]
    #
    def file?(file)
      File.basename(@file_path).casecmp?(File.basename(file))
    end

    #
    # Checks whether all objects are included in the serialization process
    #
    # @return [Boolean]
    #
    def all_objects?
      true
    end

    #
    # Updates the list of object IDs for this data file
    #
    # Any duped ID is auto. removed from the list
    #
    # @param object_ids [Array<Integer>]
    #
    def object_ids_update(*object_ids)
      @object_ids = object_ids.flatten.uniq
    end

    #
    # Clears the current list of object IDs
    #
    def object_ids_clear
      @object_ids.clear
    end

    #
    # Gets the data file name
    #
    # @return [String]
    #
    def file
      File.basename(@file_path)
    end

    #
    # Process the data file's file name for serialization
    #
    # The extension is automatically removed
    #
    # @return [String]
    #
    def serialize_file_name
      base_name = File.basename(@file_path, ".*")
      if all_objects?
        base_name
      else
        base_name.concat(DATA_FILE_CUSTOM_LABEL)
      end
    end

    #
    # Serializes the data file's object
    #
    # This method performs the necessary logic to the object for serialization
    #
    # By default, it returns the object as is
    #
    # @return [Object]
    #
    def serialize
      @object
    end

    #
    # Converts the given object list to object IDs for this data file
    #
    # The given list must be instances of this data file's contents
    #
    # By default it returns an empty array
    #
    # @param list [Array] List of objects
    #
    # @return [Array<Integer>]
    #
    def convert_list_to_ids(list)
      []
    end

    #
    # Gets a list of objects to perform a selection
    #
    # If the data file does not allow this behavior it returns ``nil``
    #
    # Returns ``nil`` by default
    #
    # @return [Array<Object>]
    #
    def to_list
      nil
    end

    #
    # Converts this instance to a string
    #
    # @return [String]
    #
    def to_s
      File.basename(@file_path)
    end

    #
    # Comparable operator (case insensitive)
    #
    # @param [Object] other Other
    #
    # @return [Integer]
    #
    def <=>(other)
      return @file_path.downcase <=> other.file_path.downcase if other.is_a?(DataFile)

      @file_path.downcase <=> other.downcase if other.is_a?(String)
    end
  end

  #
  # RPG Maker array data file
  #
  # This class expects the object to be an array
  #
  class DataFileArray < DataFile
    # Data file object (not processed)
    # @return [Array]
    attr_reader :object

    #
    # Checks whether all objects are included in the serialization process
    #
    # @return [Boolean]
    #
    def all_objects?
      object_ids.empty? || object_ids.size == object.compact.size
    end

    #
    # Serializes the data file's object
    #
    # This method prepares the object as an array
    #
    # The first element is always ``nil`` (required for RPG Maker)
    #
    # Object IDs list is used to filter the selected items on the data file
    #
    # @return [Array<Object>]
    #
    def serialize
      # Applies the selected object IDs (if any)
      processed_object = all_objects? ? object.dup : object.dup.values_at(*object_ids)

      # Returns the formatted object (with a safe-check)
      processed_object.first.nil? ? processed_object : processed_object.unshift(nil)
    end

    #
    # Converts the given object list to object IDs for this data file
    #
    # The given list must be instances of this data file's array
    #
    # @param list [Array] List of objects
    #
    # @return [Array<Integer>]
    #
    def convert_list_to_ids(list)
      list.map { |i| object.index(i) }
    end

    #
    # Gets a list of objects to perform a selection
    #
    # @return [Array<Object>]
    #
    def to_list
      # Data files needs to be compacted because TTY does not allow to create zero index based lists
      # for some data files, the first element is nil because they are created in RPG Maker database starting at 1
      # If this array is not compacted, it will cause an index mismatch later when selecting objects
      object.compact
    end
  end

  #
  # RPG Maker hash data file
  #
  # This class expects the object to be a hash
  #
  class DataFileHash < DataFile
    # Data file object (not processed)
    # @return [Hash]
    attr_reader :object

    #
    # Checks whether all objects are included in the serialization process
    #
    # @return [Boolean]
    #
    def all_objects?
      object_ids.empty? || object.all? { |key, value| object_ids.include?(key) }
    end

    #
    # Serializes the data file's object
    #
    # This method prepares the object as a hash
    #
    # Object IDs list is used to filter the correct
    #
    # @return [Hash]
    #
    def serialize
      # Dups the original object
      processed_object = object.dup

      # Applies the selected object IDs (if any)
      processed_object = processed_object.filter { |key, value| object_ids.include?(key) } unless all_objects?

      # Returns the formatted object
      processed_object
    end

    #
    # Converts the given list to object IDs for this data file
    #
    # The list must be an array of this data file hash values
    #
    # @param list [Array] List of objects
    #
    # @return [Array<Object>]
    #
    def convert_list_to_ids(list)
      list.map { |i| object.key(i) }
    end

    #
    # Gets a list of objects to perform a selection
    #
    # @return [Array<Object>]
    #
    def to_list
      # Data files needs to be compacted because TTY does not allow to create zero index based lists
      # for some data files, the first element is nil because they are created in RPG Maker database starting at 1
      # If this array is not compacted, it will cause an index mismatch later when auto-selecting objects
      object.values
    end
  end

  #
  # RPG Maker numbered hash data file
  #
  # This class expects the object to be a hash
  #
  # This class forces hash keys to be a number for the data files:
  # - Areas
  # - MapInfos
  #
  # **Reason: Creating a DataFileHash instance from a MapInfos/Areas JSON file provokes undesired behavior.**
  #
  # JSON only allows key names to be strings, so all keys of the hash will be converted to string.
  #
  # This is undesired behavior because RPG Maker editor requires the MapInfos and Areas hash keys to be numbers.
  #
  # So we need to convert all keys read from the JSON file to integers when importing the JSON file into the
  # RPG Maker database, hence the inclusion of this class specification from DataFileHash.
  #
  # Otherwise the RPG Maker editor will fail to show the maps and areas even though data still exists.
  #
  class DataFileHashNumber < DataFileHash
    #
    # Serializes the data file's object
    #
    # This method prepares the object as a hash
    #
    # Object IDs list is used to filter the correct
    #
    # @return [Hash]
    #
    def serialize
      super.transform_keys do |key|
        key.to_s.to_i
      end
    end
  end
end
