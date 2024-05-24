# frozen_string_literal: true

require "json"
require "psych"
require "fileutils"
require_relative "../model/errors"
require_relative "../model/data_file_factory"

module RgssDb
  # Relative path within the working directory to store back ups
  # @return [String]
  RGSS_BACK_UP_RELATIVE_PATH = "./Back Ups"

  # RPG Maker XP RGSS version symbol
  # @return [Symbol]
  RGSS_VERSION_XP = :rpg_maker_xp

  # RPG Maker VX RGSS version symbol
  # @return [Symbol]
  RGSS_VERSION_VX = :rpg_maker_vx

  # RPG Maker VX Ace RGSS version symbol
  # @return [Symbol]
  RGSS_VERSION_VX_ACE = :rpg_maker_vx_ace

  # Binary file format type
  # @return [Symbol]
  RGSS_FORMAT_TYPE_BINARY = :binary

  # JSON file format type
  # @return [Symbol]
  RGSS_FORMAT_TYPE_JSON = :json

  # YAML file format type
  # @return [Symbol]
  RGSS_FORMAT_TYPE_YAML = :yaml

  # JSON file format extension
  # @return [String]
  RGSS_FILE_EXT_JSON = ".json"

  # Exported YAML data file extension
  # @return [String]
  RGSS_FILE_EXT_YAML = ".yml"

  # RPG Maker XP binary data file extension
  # @return [String]
  RGSS_FILE_EXT_XP = ".rxdata"

  # RPG Maker VX binary data file extension
  # @return [String]
  RGSS_FILE_EXT_VX = ".rvdata"

  # RPG Maker VX Ace binary data file extension
  # @return [String]
  RGSS_FILE_EXT_VX_ACE = ".rvdata2"

  # Hash of all extracted file extensions
  #
  # The type of external file is used as the key, the value is the file extension string
  # @return [Hash<Symbol, String>]
  RGSS_EXTRACTED_FILE_EXTENSIONS = {
    RGSS_FORMAT_TYPE_JSON => RGSS_FILE_EXT_JSON,
    RGSS_FORMAT_TYPE_YAML => RGSS_FILE_EXT_YAML
  }.freeze

  # Hash of all database file extensions for each RPG Maker (RGSS) version
  #
  # The RPG Maker version is used as the key, the value is the file extension string
  #
  # This hash is used to detect the RPG Maker database version based on the file extension
  # @return [Hash<Symbol, String>]
  RGSS_DB_FILE_EXTENSIONS = {
    RGSS_VERSION_XP => RGSS_FILE_EXT_XP,
    RGSS_VERSION_VX => RGSS_FILE_EXT_VX,
    RGSS_VERSION_VX_ACE => RGSS_FILE_EXT_VX_ACE
  }.freeze

  # Hash that contains the appropiate database model (data classes) for each RPG Maker (RGSS) version
  #
  # The RPG Maker version is used as the key, the value is an array of file paths
  # @return [Hash<Symbol, Array<String>>]
  RGSS_DB_MODELS = {
    RGSS_VERSION_XP => [
      "../model/rpg_maker_data/xp/rgss",
      "../model/rpg_maker_data/xp/rpg"
    ],
    RGSS_VERSION_VX => [
      "../model/rpg_maker_data/vx/rgss",
      "../model/rpg_maker_data/vx/rpg"
    ],
    RGSS_VERSION_VX_ACE => [
      "../model/rpg_maker_data/vx_ace/rgss",
      "../model/rpg_maker_data/vx_ace/rpg"
    ]
  }.freeze

  # Hash of all supported database glob patterns files for each RPG Maker (RGSS) version
  #
  # The RPG Maker version is used as the key, the value is an array of glob patterns file names
  # @return [Hash<Symbol, Array<String>>]
  RGSS_DB_FILES = {
    RGSS_VERSION_XP => [
      DATA_FILE_ACTORS,
      DATA_FILE_ANIMATIONS,
      DATA_FILE_ARMORS,
      DATA_FILE_CLASSES,
      DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES,
      DATA_FILE_ITEMS,
      DATA_FILE_MAPS,
      DATA_FILE_MAP_INFOS,
      DATA_FILE_SKILLS,
      DATA_FILE_STATES,
      DATA_FILE_SYSTEM,
      DATA_FILE_TILESETS,
      DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ],
    RGSS_VERSION_VX => [
      DATA_FILE_ACTORS,
      DATA_FILE_ANIMATIONS,
      DATA_FILE_AREAS,
      DATA_FILE_ARMORS,
      DATA_FILE_CLASSES,
      DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES,
      DATA_FILE_ITEMS,
      DATA_FILE_MAPS,
      DATA_FILE_MAP_INFOS,
      DATA_FILE_SKILLS,
      DATA_FILE_STATES,
      DATA_FILE_SYSTEM,
      DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ],
    RGSS_VERSION_VX_ACE => [
      DATA_FILE_ACTORS,
      DATA_FILE_ANIMATIONS,
      DATA_FILE_ARMORS,
      DATA_FILE_CLASSES,
      DATA_FILE_COMMON_EVENTS,
      DATA_FILE_ENEMIES,
      DATA_FILE_ITEMS,
      DATA_FILE_MAPS,
      DATA_FILE_MAP_INFOS,
      DATA_FILE_SKILLS,
      DATA_FILE_STATES,
      DATA_FILE_SYSTEM,
      DATA_FILE_TILESETS,
      DATA_FILE_TROOPS,
      DATA_FILE_WEAPONS
    ]
  }.freeze

  #
  # Data manager class
  #
  class DataManager
    # Data folder path
    # @return [String]
    attr_reader :path

    # RGSS Version
    #
    # Returns ``nil`` if no version was detected
    # @return [Symbol]
    attr_reader :rgss_version

    #
    # Creates a data manager instance
    #
    # @param data_folder [String] RPG Maker database folder
    #
    def initialize(data_folder)
      @path = File.expand_path(data_folder)
      database_detect_version
      database_load_model
    end

    #
    # Checks if a valid RPG Maker version was detected or not
    #
    # @return [Boolean]
    #
    def version?
      !@rgss_version.nil?
    end

    #
    # Checks if the current RPG Maker version detected matches the given one
    #
    # The argument is automatically casted into a Symbol instance
    #
    # @param version [Symbol] RPG Maker version
    #
    # @return [Boolean]
    #
    def version_is?(version)
      @rgss_version == version.to_s.to_sym
    end

    #
    # Returns ``true`` if ``file_path`` is a RPG Maker binary data file
    #
    # Returns ``false`` if ``file_path`` is not a binary data file
    #
    # Returns ``false`` if the RGSS version could not be determined
    #
    # @param file_path [String] File path
    #
    # @return [Boolean]
    #
    def database_file?(file_path)
      File.extname(file_path).casecmp?(database_file_extension)
    end

    #
    # Returns ``true`` if the file path is a JSON file
    #
    # @param file_path [String] File path
    #
    # @return [Boolean]
    #
    def json_file?(file_path)
      File.extname(file_path).casecmp?(RGSS_FILE_EXT_JSON)
    end

    #
    # Returns ``true`` if the file path is a YAML file
    #
    # @param file_path [String] File path
    #
    # @return [Boolean]
    #
    def yaml_file?(file_path)
      File.extname(file_path).casecmp?(RGSS_FILE_EXT_YAML)
    end

    #
    # Loads a single database data file based on the given type
    #
    # @param [String] database_file_type
    #
    # @return [DataFile]
    #
    def load_database_file(database_file_type)
      # Formats the database file path
      database_file_path = File.join(@path, database_file_type + database_file_extension)

      # Creates a data file instance for this database file
      DataFileFactory.create_data_file(database_file_path, load_file(database_file_path))
    end

    #
    # Gets a list of ``DataFile`` instances based on the current path and detected version
    #
    # This method should be used to read all RPG Maker binary data files
    #
    # Returns an empty array if the operation is not possible
    #
    # @return [Array<DataFile>]
    #
    def load_database_files
      return [] unless version?

      # Formats the database file names adding the proper file extension
      database_files = database_file_names.map { |file_name| file_name + database_file_extension }

      # Scans the data folder for files
      detected_files = Dir.glob(database_files, File::FNM_CASEFOLD, base: @path)

      # Creates an array of data file instances with the detected database files
      detected_files.map do |data_file|
        data_file_path = File.expand_path(data_file, @path)
        DataFileFactory.create_data_file(data_file_path, load_file(data_file_path))
      end
    end

    #
    # Gets a list of ``DataFile`` instances based on the given directory
    #
    # All extracted files should be inside the given directory
    #
    # This method reads extracted files and returns it as data files (RPG maker data)
    #
    # Returns an empty array if the operation is not possible
    #
    # @param app_directory [String] Application working directory
    #
    # @return [Array<DataFile>]
    #
    def load_extracted_files(app_directory)
      return [] unless version?

      # Determines the application working folder directory
      base_path = File.expand_path(app_directory, @path)

      # Creates a glob pattern to detect extracted data files using file extensions
      file_extensions_glob = "{#{RGSS_EXTRACTED_FILE_EXTENSIONS.values.join(",")}}"

      # Formats all supported database files adding the file extensions glob pattern
      extracted_files = database_file_names.map do |file_name|
        file_name + file_extensions_glob
      end

      # Scans the extracted folder for complete extracted files
      detected_files = Dir.glob(extracted_files, File::FNM_CASEFOLD, base: base_path)

      # Creates an array of data file instances with the detected database files
      detected_files.map do |data_file|
        data_file_path = File.expand_path(data_file, base_path)
        DataFileFactory.create_data_file(data_file_path, load_file(data_file_path))
      end
    end

    #
    # Gets a list of ``DataFile`` instances based on the given directory
    #
    # All custom extracted files should be inside the given directory
    #
    # This method reads extracted files and returns it as data files (RPG maker data)
    #
    # Returns an empty array if the operation is not possible
    #
    # @param app_directory [String] Application working directory
    #
    # @return [Array<DataFile>]
    #
    def load_extracted_files_custom(app_directory)
      return [] unless version?

      # Determines the application working folder directory
      base_path = File.expand_path(app_directory, @path)

      # Creates a glob pattern to detect extracted data files using file extensions
      file_extensions_glob = "{#{RGSS_EXTRACTED_FILE_EXTENSIONS.values.join(",")}}"

      # Formats all supported database files adding the file extensions glob pattern
      extracted_files = database_file_names.map do |file_name|
        file_name + DATA_FILE_CUSTOM_LABEL + file_extensions_glob
      end

      # Scans the extracted folder for complete extracted files
      detected_files = Dir.glob(extracted_files, File::FNM_CASEFOLD, base: base_path)

      # Creates an array of data file instances with the detected files
      detected_files.map do |data_file|
        data_file_path = File.expand_path(data_file, base_path)
        DataFileFactory.create_data_file(data_file_path, load_file(data_file_path))
      end
    end

    #
    # Saves the given data file instance
    #
    # @param data_file [DataFile] Data file instance
    # @param app_directory [String] Application working directory
    # @param output_format_type [String] Output file format type
    #
    # @raise [StandardError] RPG Maker version is not valid
    #
    def save_data_file(data_file, app_directory, output_format_type)
      raise "cannot save data file because rpg maker version is unknown: #{@rgss_version}" unless version?

      data_file_path = File.join(
        File.expand_path(app_directory, @path),
        data_file.serialize_file_name + determine_file_extension(output_format_type)
      )
      save_file(data_file_path, data_file.serialize)
    end

    #
    # Saves a back up of the given file
    #
    # If ``file_path`` is a path, the file's base name is auto. extracted
    #
    # If the database file does not exist back up creation is skipped
    #
    # @param [String] file_path File path
    # @param [String] app_directory Application working directory
    #
    # @raise [StandardError] RPG Maker version is not valid
    #
    def save_database_back_up(file_path, app_directory)
      raise "cannot save file backup because rpg maker version is unknown: #{@rgss_version}" unless version?

      # Gets the file's base name
      database_file = File.basename(file_path, ".*")

      # Determines the absolute path to the (possible) database file
      database_file_path = File.join(@path, database_file + database_file_extension)

      # Creates a back up file if the database file exists
      save_back_up(database_file_path, app_directory) if File.file?(database_file_path)
    end

    private

    #
    # Detects the RGSS engine version on the current opened data folder
    #
    def database_detect_version
      # Gets all supported RPG Maker data file extensions
      file_extensions = RGSS_DB_FILE_EXTENSIONS.values

      # Gets all files that matches any data file extension (glob pattern)
      data_files = Dir.glob("*{#{file_extensions.join(",")}}", File::FNM_CASEFOLD, base: @path)

      # All data files within the data folder must be of the same type (aka the same RGSS version)
      file_extension = file_extensions.find do |file_ext|
        !data_files.empty? && data_files.all? { |data_file| File.extname(data_file).casecmp?(file_ext) }
      end
      @rgss_version = RGSS_DB_FILE_EXTENSIONS.key(file_extension)

      # Freeze attributes to avoid modifications
      @path.freeze
      @rgss_version.freeze
    end

    #
    # Loads the appropriate RPG Maker database classes based on the detected RPG Maker version
    #
    # Only one RPG Maker version should be loaded at a time to avoid data corruption
    #
    def database_load_model
      models = RGSS_DB_MODELS[@rgss_version]
      return if models.nil?

      models.each { |model| require_relative model }
    end

    #
    # Gets the appropiate file extension based on the detected RGSS version
    #
    # Returns ``nil`` if the RGSS version is invalid
    #
    # @return [String]
    #
    def database_file_extension
      RGSS_DB_FILE_EXTENSIONS[@rgss_version]
    end

    #
    # Gets a list of all supported database file names based on the detected RGSS version
    #
    # The list of file names has glob patterns
    #
    # Returns ``nil`` if the RGSS version is invalid
    #
    # @return [Array<String>]
    #
    def database_file_names
      RGSS_DB_FILES[@rgss_version]
    end

    #
    # Determines the file extension based on the file format type
    #
    # Returns ``nil`` if the format type is unknown
    #
    # @param format_type [Symbol]
    #
    # @return [String]
    #
    def determine_file_extension(format_type)
      case format_type
      when RGSS_FORMAT_TYPE_BINARY
        database_file_extension
      when RGSS_FORMAT_TYPE_JSON
        RGSS_FILE_EXT_JSON
      when RGSS_FORMAT_TYPE_YAML
        RGSS_FILE_EXT_YAML
      end
    end

    #
    # Loads the given file contents
    #
    # Returns ``nil`` if the operation is not possible
    #
    # @param file_path [String] File entry
    #
    # @return [Object]
    #
    def load_file(file_path)
      if database_file?(file_path)
        file_contents = File.read(file_path, mode: "rb")
        Marshal.load(file_contents)
      elsif json_file?(file_path)
        file_contents = File.read(file_path, mode: "r")
        JSON.parse(file_contents, create_additions: true)
      elsif yaml_file?(file_path)
        file_contents = File.read(file_path, mode: "r")
        Psych.unsafe_load(file_contents)
      end
    end

    #
    # Saves the data file instance
    #
    # The file path will be created if it does not exists
    #
    # @param file_path [String] File path
    # @param object [Object] object
    #
    def save_file(file_path, object)
      # Creates the directory if it does not exists
      FileUtils.mkdir_p(File.dirname(file_path))

      # Perform the write operation
      if database_file?(file_path)
        File.open(file_path, "wb") do |file|
          file << Marshal.dump(object)
        end
      elsif json_file?(file_path)
        File.open(file_path, "w") do |file|
          file << JSON.pretty_generate(object)
        end
      elsif yaml_file?(file_path)
        File.open(file_path, "w") do |file|
          file << Psych.dump(object)
        end
      end
    end

    #
    # Saves a back up of the given file
    #
    # @param file_path [String] File path
    # @param app_directory [String] Application working directory
    #
    # @raise [StandardError] File path does not exists
    #
    def save_back_up(file_path, app_directory)
      # Determine back up paths
      dest_folder = File.join(File.expand_path(app_directory, @path), RGSS_BACK_UP_RELATIVE_PATH)
      dest_file_name = "#{File.basename(file_path)} - #{current_date}.bak"
      dest_path = File.join(dest_folder, dest_file_name)

      # Creates (recursively) the back ups folder if it does not exists
      FileUtils.mkdir_p(dest_folder) unless File.directory?(dest_folder)

      # Creates a copy of the file (throws an error if it does not exists)
      FileUtils.copy_file(file_path, dest_path)
    end

    #
    # Gets the current date and time as a string
    #
    # @return [String]
    #
    def current_date
      Time.now.strftime("%Y.%m.%d - %H.%M.%S")
    end
  end
end
