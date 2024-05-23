#!/usr/bin/env ruby
# frozen_string_literal: true

require "optimist"
require_relative "./rgss_db/app"

#
# Application module
#
module RgssDb
  #
  # Entry point module
  #
  module EntryPoint
    include Strings::StrAppEntryPoint

    # Process user options with optimist before running the app
    opts = Optimist.options do
      version format(CLI_VERSION, RgssDb::VERSION)
      banner CLI_BANNER

      opt APP_OPTION_BACK_UP, CLI_OPTION_BACK_UP, short: :none, default: APP_DEFAULT_BACK_UP
      opt APP_OPTION_DEBUG_MODE, CLI_OPTION_DEBUG_MODE, type: Integer, short: :none, default: APP_DEFAULT_DEBUG_MODE
      opt APP_OPTION_WORKING_DIR, CLI_OPTION_WORKING_DIR, type: String, default: APP_DEFAULT_WORKING_DIR
      opt APP_OPTION_ACTION, CLI_OPTION_ACTION, type: String
      opt APP_OPTION_FORMAT_TYPE, CLI_OPTION_FORMAT_TYPE, type: String, default: APP_DEFAULT_FORMAT_TYPE
      opt APP_OPTION_FILE_ENTRIES, CLI_OPTION_FILE_ENTRIES, type: :strings
      opt APP_OPTION_IDS, CLI_OPTION_IDS, type: :integers, multi: true
    end

    # Gets the data directory (should be the only valid positional argument)
    path = ARGV.shift
    # Create and starts the app
    if path.nil? || path.empty?
      puts CLI_INVALID_CALL_MSG
    else
      app = RgssDb::App.new(path, opts)
      app.start
    end
  end
end
