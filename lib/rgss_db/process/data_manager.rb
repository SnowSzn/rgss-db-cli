# frozen_string_literal: true

require "json"
require "yaml"
require_relative "../errors/errors"

module RgssDb
  # Regular expression of invalid characters or sequence of characters
  INVALID_CHARACTERS = /[:*?"<>|]|(\bCON\b|\bPRN\b|\bAUX\b|\bNUL\b|\bCOM[1-9]\b|\bLPT[1-9]\b)/i

  # Unknown RGSS version symbol
  RGSS_VERSION_UNKNOWN = :unknown

  # RPG Maker XP RGSS version symbol
  RGSS_VERSION_XP = :rpg_maker_xp

  # RPG Maker VX RGSS version symbol
  RGSS_VERSION_VX = :rpg_maker_vx

  # RPG Maker VX Ace RGSS version symbol
  RGSS_VERSION_VX_ACE = :rpg_maker_vx_ace

  # Hash of all supported database glob patterns files for each RPG Maker version
  #
  # The RPG Maker version is used as the key, the value is an array of glob patterns
  RGSS_DATABASE_FILES = {
    RGSS_VERSION_XP => [
      "Actors.rxdata",
      "Animations.rxdata",
      "Armors.rxdata",
      "Classes.rxdata",
      "CommonEvents.rxdata",
      "Enemies.rxdata",
      "Items.rxdata",
      "Map[0-9][0-9][1-9].rxdata",
      "MapInfos.rxdata",
      "Skills.rxdata",
      "States.rxdata",
      "System.rxdata",
      "Tilesets.rxdata",
      "Troops.rxdata",
      "Weapons.rxdata"
    ],
    RGSS_VERSION_VX => [
      "Actors.rvdata",
      "Animations.rvdata",
      "Areas.rvdata",
      "Armors.rvdata",
      "Classes.rvdata",
      "CommonEvents.rvdata",
      "Enemies.rvdata",
      "Items.rvdata",
      "Map[0-9][0-9][1-9].rvdata",
      "MapInfos.rvdata",
      "Skills.rvdata",
      "States.rvdata",
      "System.rvdata",
      "Troops.rvdata",
      "Weapons.rvdata"
    ],
    RGSS_VERSION_VX_ACE => [
      "Actors.rvdata2",
      "Animations.rvdata2",
      "Armors.rvdata2",
      "Classes.rvdata2",
      "CommonEvents.rvdata2",
      "Enemies.rvdata2",
      "Items.rvdata2",
      "Map[0-9][0-9][1-9].rvdata2",
      "MapInfos.rvdata2",
      "Skills.rvdata2",
      "States.rvdata2",
      "System.rvdata2",
      "Tilesets.rvdata2",
      "Troops.rvdata2",
      "Weapons.rvdata2"
    ]
  }.freeze

  #
  # Data manager class
  #
  class DataManager
    # Absolute path to the data folder
    # @return [String]
    attr_reader :path
    # RGSS Version
    # @return [Symbol]
    attr_reader :rgss_version

    #
    # Creates a data manager instance
    #
    # @param [String] data_folder RPG Maker database folder
    #
    def initialize(data_folder)
      @path = File.expand_path(data_folder)
      @rgss_version = RGSS_VERSION_UNKNOWN
      determine_rgss_version
      load_database_classes
    end

    #
    # Checks if the current RGSS version detected matches RPG Maker XP version
    #
    # @return [Boolean] Version status
    #
    def version_xp?
      @rgss_version == RGSS_VERSION_XP
    end

    #
    # Checks if the current RGSS version detected matches RPG Maker VX version
    #
    # @return [Boolean] Version status
    #
    def version_vx?
      @rgss_version == RGSS_VERSION_VX
    end

    #
    # Checks if the current RGSS version detected matches RPG Maker VX Ace version
    #
    # @return [Boolean] Version status
    #
    def version_vx_ace?
      @rgss_version == RGSS_VERSION_VX_ACE
    end

    #
    # Checks if the detected RGSS version is unknown
    #
    # @return [Boolean] Version status
    #
    def version_unknown?
      @rgss_version == RGSS_VERSION_UNKNOWN
    end

    #
    # Validates the path
    #
    # @param [String] path Path
    #
    # @return [Boolean] Path validness
    #
    def validate_path(path)
      !path.match?(INVALID_CHARACTERS)
    end

    #
    # Gets a list of RPG Maker data files based on the current path and detected version
    #
    # Returns an empty array ``[]`` if the RPG Maker version is unknown
    #
    # @return [Array<String>] List of RPG Maker data files
    #
    def data_files
      return [] if version_unknown?

      Dir.glob(RGSS_DATABASE_FILES[@rgss_version], File::FNM_CASEFOLD, base: @path)
    end

    def pack(path, entries, ids)
      data_file = "C:/Users/ferna/OneDrive/Escritorio/Stuff/GitHub/rgss-db-cli/spec/tests/Items.rvdata2"
      p "================================================================"
      p "read test..."
      contents = ""
      File.open(data_file, "rb") do |file|
        contents = Marshal.load(file.read)
      end
      p contents
      p "================================================================"
      p "writing json and yaml..."
      json_str = JSON.pretty_generate(contents)
      yaml_str = YAML.dump(contents)
      File.write("C:/Users/ferna/OneDrive/Escritorio/Stuff/GitHub/rgss-db-cli/spec/tests/out/items.json", json_str)
      File.write("C:/Users/ferna/OneDrive/Escritorio/Stuff/GitHub/rgss-db-cli/spec/tests/out/yaml.json", yaml_str)
      p "================================================================"
      p "writing test..."
      marshalized = Marshal.dump(contents)
      File.write("C:/Users/ferna/OneDrive/Escritorio/Stuff/GitHub/rgss-db-cli/spec/tests/out/items.rvdata2",
                 marshalized, mode: "wb")
      p "================================================================"
      p "reading test 2..."
      file_path = "C:/Users/ferna/OneDrive/Escritorio/Stuff/GitHub/rgss-db-cli/spec/tests/out/items.rvdata2"
      File.open(file_path, "rb") do |file|
        contents = Marshal.load(file.read)
      end
      p contents
      # case @rgss_version
      # when RGSS_VERSION_XP
      #   puts "packing for xp"
      # when RGSS_VERSION_VX
      #   puts "packing for vx"
      # when RGSS_VERSION_VX_ACE
      #   puts "packing for vx ace"
      # else
      #   raise Error, "unknown rpg maker version!"
      # end
    end

    def unpack(path, entries, ids, output_format)
      # case @rgss_version
      # when RGSS_VERSION_XP
      #   puts "unpacking for xp"
      # when RGSS_VERSION_VX
      #   puts "unpacking for vx"
      # when RGSS_VERSION_VX_ACE
      #   puts "unpacking for vx ace"
      #   # raise Error, "unsupported file format detected!" unless rpg_maker_vx_ace?(entries)
      # else
      #   raise Error, "unknown rpg maker version!"
      # end
    end

    private

    #
    # Determines the RGSS version on the current opened data folder
    #
    def determine_rgss_version
      data_files = Dir.glob("*.{rxdata,rvdata,rvdata2}", File::FNM_CASEFOLD, base: @path)
      # All data files within the data folder must be of the same type (aka the same RGSS version)
      @rgss_version = RGSS_VERSION_UNKNOWN
      @rgss_version = RGSS_VERSION_XP if rpg_maker_xp?(data_files)
      @rgss_version = RGSS_VERSION_VX if rpg_maker_vx?(data_files)
      @rgss_version = RGSS_VERSION_VX_ACE if rpg_maker_vx_ace?(data_files)
    end

    #
    # Loads the appropriate RPG Maker database classes based on the detected RPG Maker version
    #
    def load_database_classes
      # Require the appropiate rpg maker database classes
      case @rgss_version
      when RGSS_VERSION_XP
        require_relative "../data/xp/rpg"
        require_relative "../data/xp/rgss"
      when RGSS_VERSION_VX
        require_relative "../data/vx/rpg"
        require_relative "../data/vx/rgss"
      when RGSS_VERSION_VX_ACE
        require_relative "../data/vx_ace/rpg"
        require_relative "../data/vx_ace/rgss"
      end
    end

    #
    # Gets whether all files in ``data_files`` are data files from RPG Maker XP
    #
    # @param [Array<String>] data_files List of files
    #
    # @return [Boolean]
    #
    def rpg_maker_xp?(data_files)
      return true if !data_files.empty? && data_files.all? { |file| file.to_s.downcase.end_with?(".rxdata") }

      false
    end

    #
    # Gets whether all files in ``data_files`` are data files from RPG Maker VX
    #
    # @param [Array<String>] data_files List of files
    #
    # @return [Boolean]
    #
    def rpg_maker_vx?(data_files)
      return true if !data_files.empty? && data_files.all? { |file| file.to_s.downcase.end_with?(".rvdata") }

      false
    end

    #
    # Gets whether all files in ``data_files`` are data files from RPG Maker VX Ace
    #
    # @param [Array<String>] data_files List of files
    #
    # @return [Boolean]
    #
    def rpg_maker_vx_ace?(data_files)
      return true if !data_files.empty? && data_files.all? { |file| file.to_s.downcase.end_with?(".rvdata2") }

      false
    end
  end
end
