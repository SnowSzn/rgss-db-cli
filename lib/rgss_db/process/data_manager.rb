# frozen_string_literal: true

require "json"
require "yaml"
require_relative "../errors/errors"

module RgssDb
  # Unknown RGSS version symbol
  RGSS_VERSION_UNKNOWN = :unknown

  # RPG Maker XP RGSS version symbol
  RGSS_VERSION_XP = :rpg_maker_xp

  # RPG Maker VX RGSS version symbol
  RGSS_VERSION_VX = :rpg_maker_vx

  # RPG Maker VX Ace RGSS version symbol
  RGSS_VERSION_VX_ACE = :rpg_maker_vx_ace

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
      data_files = Dir.glob("*.{rxdata,rvdata,rvdata2}", base: @path)
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
      return true if !data_files.empty? && data_files.all? { |file| file.end_with?(".rxdata") }

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
      return true if !data_files.empty? && data_files.all? { |file| file.end_with?(".rvdata") }

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
      return true if !data_files.empty? && data_files.all? { |file| file.end_with?(".rvdata2") }

      false
    end
  end
end
