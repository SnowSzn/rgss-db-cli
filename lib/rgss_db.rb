#!/usr/bin/env ruby
# frozen_string_literal: true

# TODO: Possible uses:
#
# Show help if no args given
# rgss-db
#
# Open CLI UI menu (if a path is given)
# rgss-db .
#
# Direct call: pack/unpack all files
# rgss-db . -a unpack
# rgss-db . -a pack
#
# Direct call: pack/unpack an specific file
# rgss-db . -a unpack -f Items.rvdata2
# rgss-db . -a pack -f Items.json
#
# Direct call: pack/unpack an specific item ID inside a file
# rgss-db . -a unpack -f Items.rvdata2 -i 4
#
# Direct call: Argument -o / --output will be used determine output file format (default: yaml)
# rgss-db . -a unpack -f Items.rvdata2 -i 4 -o json
# rgss-db . -a unpack -o json
# rgss-db . -a unpack -f Items.rvdata2 -o json

# TODO: the option --ids should only work when --files is a single file
# avoid extracting the specified item IDs from a list of files because some of them may no exist

require "optimist"
require_relative "./rgss_db/app"
require_relative "./rgss_db/version"

#
# rgss db entry point
#
module RgssDb
  # Process user options with optimist before running the app
  opts = Optimist.options do
    version "rgss-db version #{RgssDb::VERSION}"
    banner <<~DESCRIPTION
      rgss-db is a development tool for developers who want to deserialize the database files created by RPG Maker into external readable files like JSON or YAML.

      It also allows to serialize these same external files back to the appropiate format based on the detected RPG Maker version.

      This tool works on any RPG Maker editor based on RGSS:
      - RPG Maker XP
      - RPG Maker VX
      - RPG Maker VX Ace

      If the command is called without specifying options and only giving the directory of the data, a main menu will be displayed where you can perform the desired action:
        # Opens the current directory
        rgss-db .

      You can skip this menu if you provide the correct options to perform an action, for example:

      If you want to extract all data files from an RPG Maker game, you can do:
        rgss-db . -a #{APP_CMD_ACTION_UNPACK}

      You can use other options to modify the behaviour of the action performed, for example:
        rgss-db . -a #{APP_CMD_ACTION_UNPACK} -f #{APP_FORMAT_TYPE_JSON}

      Usage:
        rgss-db data_directory [options]

      Options:
    DESCRIPTION

    opt APP_OPTION_ACTION, "Sets the action to perform automatically", type: String
    opt APP_OPTION_FILE_ENTRIES, "Sets a list of file entries on which the action will be performed", type: :strings
    opt APP_OPTION_IDS, "Sets a list of IDs that will be affected", type: :integers
    opt APP_OPTION_FORMAT, "Specifies the output format file", type: String, default: APP_DEFAULT_FORMAT_TYPE
    opt APP_OPTION_OUTPUT_PATH, "Sets the output path", type: String, default: APP_DEFAULT_OUTPUT_PATH
  end

  # Gets the data directory (should be the only valid positional argument)
  path = ARGV.shift
  # Create and start the app loop
  if path.nil? || path.empty?
    puts "Please provide a data directory!"
    puts "Use 'rgss-db --help' to get more information"
  else
    app = RgssDb::App.new(path, opts)
    app.start
  end
end
