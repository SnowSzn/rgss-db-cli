# frozen_string_literal: true

require_relative "./data_file"

module RgssDb
  #
  # Data file factory module
  #
  module DataFileFactory
    # List of all data files types
    FACTORY_ALL_TYPES = [
      DATA_FILE_ACTORS,
      DATA_FILE_ANIMATIONS,
      DATA_FILE_AREAS,
      DATA_FILE_ARMORS,
      DATA_FILE_CLASSES,
      DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES,
      DATA_FILE_ITEMS,
      DATA_FILE_MAP_INFOS,
      DATA_FILE_MAPS,
      DATA_FILE_SKILLS,
      DATA_FILE_STATES,
      DATA_FILE_SYSTEM,
      DATA_FILE_TILESETS,
      DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ].freeze

    # List of data files handled using an array
    #
    # Some RPG Maker database files are saved as arrays (Actors, Weapons, Items...)
    # @return [Array<String>]
    FACTORY_ARRAY = [
      DATA_FILE_ACTORS, DATA_FILE_ANIMATIONS,
      DATA_FILE_ARMORS, DATA_FILE_CLASSES, DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES, DATA_FILE_ITEMS, DATA_FILE_SKILLS,
      DATA_FILE_STATES, DATA_FILE_TILESETS, DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ].freeze

    # List of data files handled using a hash
    # @return [Array<String>]
    FACTORY_HASH = [].freeze

    # List of data files handled using a number hash
    # @return [Array<String>]
    FACTORY_HASH_NUMBER = [
      DATA_FILE_AREAS,
      DATA_FILE_MAP_INFOS
    ].freeze

    #
    # Creates a data file instance based on the given file entry
    #
    # The database file type is auto. determined using the ``data_file`` path
    #
    # @param data_file [String] Data file entry
    # @param object [Object] Deserialized data file object
    #
    # @return [DataFile]
    #
    # @raise [StandardError] No type found
    #
    def self.create_data_file(data_file, object)
      type = determine_data_file_type(data_file)
      raise "could not find a valid data file type for the file: '#{data_file}'" if type.nil?

      # Checks for a specific data file usage (bulk-check)
      return DataFileArray.new(type, data_file, object) if FACTORY_ARRAY.any? { |f| f.casecmp?(type) }
      return DataFileHash.new(type, data_file, object) if FACTORY_HASH.any? { |f| f.casecmp?(type) }
      return DataFileHashNumber.new(type, data_file, object) if FACTORY_HASH_NUMBER.any? { |f| f.casecmp?(type) }

      # Assume a base data file (map data files will use this)
      DataFile.new(type, data_file, object)
    end

    #
    # Determines the type of the data file
    #
    # Returns ``nil`` if a valid type cannot be found
    #
    # @param [String] data_file Data file entry
    #
    # @return [String]
    #
    def self.determine_data_file_type(data_file)
      # Gets the data file name without extensions (and custom label, if any)
      data_file_name = File.basename(data_file, ".*").gsub(DATA_FILE_CUSTOM_LABEL, "")
      FACTORY_ALL_TYPES.find { |type| File.fnmatch(type, data_file_name, File::FNM_CASEFOLD) }
    end
  end
end
