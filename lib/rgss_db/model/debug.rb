# frozen_string_literal: true

require "fileutils"

module RgssDb
  #
  # Debug module
  #
  module Debug
    # Debug log file name
    DEBUG_FILE_NAME = "rgss-db.log"

    # Debug mode disabled
    DEBUG_MODE_DISABLE = 0

    # Debug mode errors and below
    DEBUG_MODE_ERROR = 1

    # Debug mode warnings and below
    DEBUG_MODE_WARNING = 2

    # Debug mode info and below
    DEBUG_MODE_INFO = 3

    # Debug absolute file path
    @debug_file_path = ""

    # Debug mode
    @debug_mode = 0

    # Debug extra information
    @debug_extra_info = ""

    #
    # Starts the debug module with the given information
    #
    # Optionally sets the debug mode
    #
    # @param debug_file_path [String] Path to the debug file
    # @param debug_mode [Integer] Debug mode
    #
    def self.start(debug_file_path, debug_mode = nil)
      @debug_file_path = File.join(debug_file_path, DEBUG_FILE_NAME)
      @debug_mode = debug_mode unless debug_mode.nil?

      # Creates the directory (recursively)
      FileUtils.mkdir_p(debug_file_path)

      # Overwrites file if it exists already
      File.truncate(@debug_file_path, 0) if File.exist?(@debug_file_path)
    end

    #
    # Gets the debug mode
    #
    # @return [Integer]
    #
    def self.debug_mode
      @debug_mode
    end

    #
    # Sets the debug mode
    #
    # Set to 0 to disable
    #
    # @param debug_mode [Integer] Debug mode
    #
    def self.update_debug_mode(debug_mode)
      @debug_mode = debug_mode
    end

    #
    # Sets the debug extra information
    #
    # @param extra_info [Array<String>]
    #
    def self.update_extra_info(*extra_info)
      @debug_extra_info = extra_info
    end

    #
    # Writes the debug header to the log file
    #
    def self.write_debug_header
      log("<--- debug module started --->")
      log("debug mode: #{Debug.debug_mode}")
      log("debug extra:")
      @debug_extra_info.each { |str| log("\t- #{str}") }
      log("<---------------------------->")
    end

    #
    # Logs the string
    #
    # @param string [String]
    #
    def self.log(string)
      File.write(@debug_file_path, "#{string}\n", mode: "a") unless disabled?
    end

    #
    # Logs the string as information
    #
    # @param string [String]
    #
    def self.log_info(string)
      log("info: #{string}") if info?
    end

    #
    # Logs the string as an error
    #
    # @param string [String]
    #
    def self.log_error(string)
      log("error: #{string}") if error?
    end

    #
    # Logs the string as a warning
    #
    # @param string [String]
    #
    def self.log_warning(string)
      log("warning: #{string}") if warning?
    end

    #
    # Checks whether the debug module is disabled or not
    #
    # @return [Boolean]
    #
    def self.disabled?
      @debug_mode == DEBUG_MODE_DISABLE
    end

    #
    # Checks whether the debug mode is info or not
    #
    # @return [Boolean]
    #
    def self.info?
      @debug_mode >= DEBUG_MODE_INFO
    end

    #
    # Checks whether the debug mode is error or not
    #
    # @return [Boolean]
    #
    def self.error?
      @debug_mode >= DEBUG_MODE_ERROR
    end

    #
    # Checks whether the debug mode is warning or not
    #
    # @return [Boolean]
    #
    def self.warning?
      @debug_mode >= DEBUG_MODE_WARNING
    end
  end
end
