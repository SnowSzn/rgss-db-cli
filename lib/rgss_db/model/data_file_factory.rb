# frozen_string_literal: true

require_relative "./data_file"

module RgssDb
  #
  # Data file factory module
  #
  module DataFileFactory
    # List of data files handled using an array
    #
    # Some RPG Maker database files are saved as arrays (Actors, Weapons, Items...)
    # @return [Array<String>]
    FACTORY_ARRAY_FILES = [
      DATA_FILE_ACTORS, DATA_FILE_ANIMATIONS, DATA_FILE_AREAS,
      DATA_FILE_ARMORS, DATA_FILE_CLASSES, DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES, DATA_FILE_ITEMS, DATA_FILE_SKILLS,
      DATA_FILE_STATES, DATA_FILE_TILESETS, DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ].freeze

    # List of data files handled using a hash
    #
    # RPG Maker MapInfos database files are saved as hashes
    # @return [Array<String>]
    FACTORY_HASH_FILES = [
      DATA_FILE_MAP_INFOS
    ].freeze

    #
    # Creates a data file instance based on the given file entry
    #
    # @param data_file [String] Data file entry
    # @param object [Object] Deserialized data file object
    #
    # @return [DataFile]
    #
    def self.create_data_file(data_file, object)
      data_file_name = File.basename(data_file, ".*")

      # Checks for a specific data file usage
      return DataFileArray.new(data_file, object) if FACTORY_ARRAY_FILES.any? { |f| f.casecmp?(data_file_name) }
      return DataFileHash.new(data_file, object) if FACTORY_HASH_FILES.any? { |f| f.casecmp?(data_file_name) }

      # Assume a base data file (map data files will use this)
      DataFile.new(data_file, object)
    end
  end
end
