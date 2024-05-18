# frozen_string_literal: true

module RgssDb
  #
  # Debug module
  #
  module Debug
    # Debug file
    DEBUG_FILE_NAME = "rgss-db.log"

    # Debug mode disabled
    DEBUG_MODE_DISABLE = 0

    # Debug mode info and below
    DEBUG_MODE_INFO = 1

    # Debug mode errors and below
    DEBUG_MODE_ERROR = 2

    # Debug mode warnings and below
    DEBUG_MODE_WARNING = 3

    # Debug mode verbose and below
    DEBUG_MODE_VERBOSE = 4

    # Debug absolute file path
    @debug_file_path = ""

    # Debug mode
    @debug_mode = 0

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
    # Logs the string as information
    #
    # @param string [String]
    #
    def self.log(string)
      File.write(@debug_file_path, "#{string}\n", mode: "a") if info?
    end

    #
    # Logs the string as an error
    #
    # @param string [String]
    #
    def self.log_error(string)
      File.write(@debug_file_path, "error: #{string}\n", mode: "a") if error?
    end

    #
    # Logs the string as a warning
    #
    # @param string [String]
    #
    def self.log_warning(string)
      File.write(@debug_file_path, "warning: #{string}\n", mode: "a") if warning?
    end

    #
    # Logs the string as a verbose message
    #
    # @param string [String]
    #
    def self.log_verbose(string)
      File.write(@debug_file_path, "verbose: #{string}\n", mode: "a") if verbose?
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

    #
    # Checks whether the debug mode is verbose or not
    #
    # @return [Boolean]
    #
    def self.verbose?
      @debug_mode >= DEBUG_MODE_VERBOSE
    end
  end
end
