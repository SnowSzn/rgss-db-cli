# frozen_string_literal: true

require "colorize"
require "tty-screen"
require "tty-box"
require "tty-table"
require "tty-prompt"
require "tty-progressbar"
require "tty-spinner"
require_relative "./version"

module RgssDb
  # App option action type
  APP_OPTION_ACTION = :action

  # App option file entries
  APP_OPTION_FILE_ENTRIES = :entries

  # App option object ids
  APP_OPTION_IDS = :ids

  # App option format
  APP_OPTION_FORMAT = :format

  # App option output path
  APP_OPTION_OUTPUT_PATH = :output

  # Default format type of the application
  APP_DEFAULT_FORMAT_TYPE = "yaml"

  # Default output path for the application
  APP_DEFAULT_OUTPUT_PATH = "./rgss-db"

  # Output file format type for JSON files
  APP_FORMAT_TYPE_JSON = "json"

  # Output file format type for YAML files
  APP_FORMAT_TYPE_YAML = "yaml"

  # Unpack data action command name
  #
  # This action unpacks the binary files (into external files)
  APP_CMD_ACTION_UNPACK = "unpack"

  # Pack data action command name
  #
  # This action packs external files into binary files
  APP_CMD_ACTION_PACK = "pack"

  # App menu option to go to the actions menu
  APP_MENU_ACTIONS = "Perform Actions"

  # App menu option for unpacking command
  APP_MENU_ACTIONS_UNPACK = "Unpack RPG Maker Files"

  # App menu option for packing command
  APP_MENU_ACTIONS_PACK = "Pack External Data into RPG Maker Files"

  # App menu option to go to the check and change app options menu
  APP_MENU_OPTIONS = "Check and Modify Options"

  # App menu option to select a list of file entries
  APP_MENU_OPTIONS_SET_ENTRIES = "Set File Entries List"

  # App menu option to select a list of object IDs
  APP_MENU_OPTIONS_SET_IDS = "Set Object IDs List"

  # App menu option to set the output file format type
  APP_MENU_OPTIONS_SET_FORMAT = "Set Type of File Format"

  # App menu option to set the output path
  APP_MENU_OPTIONS_SET_OUTPUT_PATH = "Set Output Path"

  # App menu option to show the values of the current options (pretty format)
  APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY = "Show Options (Pretty)"

  # App menu option to show the values of the current options (raw format)
  APP_MENU_OPTIONS_SHOW_OPTIONS_RAW = "Show Options (Raw)"

  # App menu option for exiting command
  APP_MENU_EXIT = "Exit"

  # Value that determines the number of options per page on the select prompt
  APP_VAL_SELECT_PER_PAGE = 5

  # Value that determines the number of options per page on the multi select prompt
  APP_VAL_ENUM_SELECT_PER_PAGE = 10

  #
  # Application CLI class
  #
  class App
    #
    # Creates a new app instance
    #
    # @param [String] data_path Path to the project data directory
    # @param [Hash<Symbol, Object>] options Hash of options
    #
    def initialize(data_path, options)
      @options = process_options(options)
      @prompt = TTY::Prompt.new
    end

    #
    # Starts the app
    #
    # If no valid options are passed, it will show the app's main menu
    #
    def start
      # TODO: Deal with either showing the app's menu
      # or if the proper options were provided, perform the appropriate operation (unpack/pack...)
      # if direct operation? -> avoid main menu loop
      option_action = @options[APP_OPTION_ACTION]
      if option_action
        # An action was given, avoid main menu loop
        puts "running action: #{option_action}"
      else
        # No action given, run the app main menu loop
        cli_menu_main
      end
    end

    private

    #
    # Process the user options
    #
    # @param [Hash<Symbol, Object>] options_hash Options hash
    #
    # @return [Hash<Symbol, Object>] Processed hash
    #
    def process_options(options_hash)
      options = {}
      options_hash.each_pair do |option_id, option_value|
        case option_id
        when APP_OPTION_ACTION
          # Process the action option (case insensitive)
          if option_value.to_s.casecmp?(APP_CMD_ACTION_PACK)
            options.store(option_id, APP_CMD_ACTION_PACK)
          elsif option_value.to_s.casecmp?(APP_CMD_ACTION_UNPACK)
            options.store(option_id, APP_CMD_ACTION_UNPACK)
          else
            # Unknown action value
            options.store(option_id, nil)
          end
        when APP_OPTION_FORMAT
          # Process the output file format option (case insensitive)
          if option_value.to_s.casecmp?(APP_FORMAT_TYPE_JSON)
            options.store(option_id, APP_FORMAT_TYPE_JSON)
          elsif option_value.to_s.casecmp?(APP_FORMAT_TYPE_YAML)
            options.store(option_id, APP_FORMAT_TYPE_YAML)
          else
            # Sets to default value if unknown
            options.store(option_id, APP_DEFAULT_FORMAT_TYPE)
          end
        when APP_OPTION_OUTPUT_PATH
          # Process the output path option
          options.store(option_id, option_value || APP_DEFAULT_OUTPUT_PATH)
        when APP_OPTION_FILE_ENTRIES
          # Process the list of pre-selected file entries option
          options.store(option_id, option_value || [])
        when APP_OPTION_IDS
          # Process the list of pre-selected object IDs per file entry option
          options.store(option_id, {})
          # Populate the hash based on the given file entries list
          (options_hash[APP_OPTION_FILE_ENTRIES] || []).each_with_index do |file, index|
            id_list = option_value.at(index)
            options[option_id].store(file, id_list) unless id_list.nil?
          end
        else
          # Option does not need treatment
          options.store(option_id, option_value)
        end
      end
      options
    end

    #
    # Resets the console screen position with a escape sequence
    #
    def cli_reset_screen
      puts "\e[H\e[2J"
    end

    #
    # Draws and runs a confirmation sequence on the standard output
    #
    # By default the confirmation will return ``false`` unless otherwise specified
    #
    # @param [String] message Message to show
    # @param [Boolean] default Default value
    #
    # @return [Boolean] Confirmation status
    #
    def cli_confirm?(message, default: true)
      @prompt.yes?(message, default: default)
    end

    #
    # Draws and runs the press any key to continue to the standard output
    #
    # If ``timeout`` is specified, it will resume execution after that time has passed.
    #
    # @param [Array<Symbol>] keys List of allowed keys to be pressed
    # @param [Integer] timeout Time out in seconds
    #
    def cli_press_key_continue(keys: [], timeout: nil)
      if keys.empty?
        # No specific keys
        if timeout
          @prompt.keypress(
            "Press any key to continue... (resumes automatically in #{timeout} seconds)".colorize(:green),
            timeout: timeout
          )
        else
          @prompt.keypress(
            "Press any key to continue...".colorize(:green)
          )
        end
      else
        # Specific keys
        key_names = keys.map { |key| key.to_s.upcase }.join(" or ")
        if timeout
          @prompt.keypress(
            "Press #{key_names} to continue... (resumes automatically in #{timeout} seconds)".colorize(:green),
            keys: keys,
            timeout: timeout
          )
        else
          @prompt.keypress(
            "Press #{key_names} to continue...".colorize(:green),
            keys: keys
          )
        end
      end
    end

    #
    # Draws an empty line on the standard output
    #
    def cli_draw_empty_line
      puts ""
    end

    #
    # Draws the given ``string`` line on the standard output
    #
    # @param [String] string String
    # @param [Symbol] color Color symbol
    #
    def cli_draw_line(string, color = nil)
      puts color ? string.to_s.colorize(color) : string.to_s
    end

    #
    # Draws the user's navigation in the standard output
    #
    # @param [Array<String>] breadcrumbs List of breadcrumbs
    #
    def cli_draw_navigation(*breadcrumbs)
      puts breadcrumbs.join(" -> ").colorize(:blue)
    end

    #
    # Draws an information frame with the given contents on the standard output
    #
    # The value of ``site`` will be shown on the bottom right corner of the frame
    #
    # @param [Array<String>] contents Frame contents
    # @param [String] site Site
    #
    def cli_draw_info_frame(*contents, site: nil)
      box = TTY::Box.frame(
        *contents,
        title: { top_left: "ℹ  Information", bottom_right: site }
      )
      puts box
    end

    #
    # Draws a warning frame with the given contents on the standard output
    #
    # The value of ``site`` will be shown on the bottom right corner of the frame
    #
    # @param [Array<String>] contents Frame contents
    # @param [String] site Site
    #
    def cli_draw_warning_frame(*contents, site: nil)
      box = TTY::Box.frame(
        *contents,
        title: { top_left: "⚠  Warning", bottom_right: site }
      )
      puts box.colorize(:yellow)
    end

    #
    # Draws a table on the standard output
    #
    # The number of ``columns`` and the size of each row in ``rows`` must have the same length
    #
    # Columns: [Column1, Column2]
    # Rows: [["a", "b"], ["c", "d"]]
    #
    # @param [Array<String>] columns Columns
    # @param [Array<String>] rows List of rows
    # @param [Symbol] render_type Render type
    #
    def cli_draw_table(columns, *rows, render_type: :unicode)
      table = TTY::Table.new(
        columns,
        rows
      )
      puts table.render(render_type)
    end

    #
    # Draws the app header information on the standard output
    #
    def cli_draw_header
      # App title
      puts <<~EOF
        ██████   ██████  ███████ ███████     ██████   █████  ████████  █████  ██████   █████  ███████ ███████
        ██   ██ ██       ██      ██          ██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██ ██      ██
        ██████  ██   ███ ███████ ███████     ██   ██ ███████    ██    ███████ ██████  ███████ ███████ █████
        ██   ██ ██    ██      ██      ██     ██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██      ██ ██
        ██   ██  ██████  ███████ ███████     ██████  ██   ██    ██    ██   ██ ██████  ██   ██ ███████ ███████
                                                                                                       v#{VERSION}
      EOF
        .colorize(:green)
      # warning panel
      cli_draw_empty_line
    end

    #
    # Draws and runs the main menu selection process
    #
    def cli_menu_main
      loop do
        cli_reset_screen
        cli_draw_header
        cli_draw_empty_line
        cli_draw_navigation("Main Menu")
        cli_draw_empty_line
        option = @prompt.select(
          "What would you like to do?",
          [
            APP_MENU_ACTIONS,
            APP_MENU_OPTIONS,
            APP_MENU_EXIT
          ],
          per_page: APP_VAL_SELECT_PER_PAGE
        )
        case option
        when APP_MENU_ACTIONS
          cli_menu_actions
        when APP_MENU_OPTIONS
          cli_menu_modify_options
        when APP_MENU_EXIT
          cli_draw_line "Exiting...", :red
          break
        end
      end
    end

    #
    # Draws and runs the action menu to perform actions
    #
    def cli_menu_actions
      loop do
        cli_reset_screen
        cli_draw_header
        cli_draw_empty_line
        cli_draw_navigation("Main Menu", APP_MENU_ACTIONS)
        cli_draw_empty_line
        cli_draw_info_frame(
          "You can use this menu to perform actions on the current RPG Maker database",
          "",
          "You will be able to choose which files to execute the action on",
          "",
          "Also, if the files allow it, which objects will be affected"
        )
        cli_draw_empty_line
        option = @prompt.select(
          "What would you like to do?",
          [
            APP_MENU_ACTIONS_PACK,
            APP_MENU_ACTIONS_UNPACK,
            APP_MENU_EXIT
          ],
          per_page: APP_VAL_SELECT_PER_PAGE
        )
        case option
        when APP_MENU_ACTIONS_PACK
          cli_submenu_pack
        when APP_MENU_ACTIONS_UNPACK
          cli_submenu_unpack
        when APP_MENU_EXIT
          cli_draw_line "Exiting...", :red
          break
        end
      end
    end

    #
    # Draws and runs the options menu to modify options values
    #
    def cli_menu_modify_options
      loop do
        cli_reset_screen
        cli_draw_header
        cli_draw_empty_line
        cli_draw_navigation("Main Menu", APP_MENU_OPTIONS)
        cli_draw_empty_line
        cli_draw_info_frame(
          "You can use this menu to change the value of the options available to the user",
          "",
          "You are also able to see the value of each option in a table"
        )
        cli_draw_empty_line
        option = @prompt.select(
          "What would you like to do?",
          [
            APP_MENU_OPTIONS_SET_FORMAT,
            APP_MENU_OPTIONS_SET_OUTPUT_PATH,
            APP_MENU_OPTIONS_SET_ENTRIES,
            APP_MENU_OPTIONS_SET_IDS,
            APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY,
            APP_MENU_OPTIONS_SHOW_OPTIONS_RAW,
            APP_MENU_EXIT
          ],
          per_page: APP_VAL_SELECT_PER_PAGE
        )
        case option
        when APP_MENU_OPTIONS_SET_FORMAT
          cli_submenu_set_file_format
        when APP_MENU_OPTIONS_SET_OUTPUT_PATH
          cli_submenu_set_output_path
        when APP_MENU_OPTIONS_SET_ENTRIES
          cli_submenu_set_entries
        when APP_MENU_OPTIONS_SET_IDS
          cli_submenu_set_ids
        when APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY
          cli_submenu_show_options_pretty
        when APP_MENU_OPTIONS_SHOW_OPTIONS_RAW
          cli_submenu_show_options_raw
        when APP_MENU_EXIT
          cli_draw_line "Exiting...", :red
          break
        end
      end
    end

    #
    # Draws and runs the submenu for unpacking data files
    #
    def cli_submenu_unpack
      cli_reset_screen
      cli_draw_info_frame(
        "Choose which data files you want to unpack from the list of files below",
        "",
        "Press ↑/↓ arrows to move the cursor",
        "Use SPACE to select the current item",
        "Press CTRL + A and to select all items available",
        "You can also use CTRL + R to revert the current selection",
        "Press ENTER to finish selection"
      )
      cli_draw_empty_line
      data_files = ["Items.rvdata2", "Weapons.rvdata2"]
      # Checks validness of data files
      if data_files.empty?
        cli_draw_line "No data files found in the data folder!", :red
        cli_draw_empty_line
        cli_press_key_continue
        return
      end
      # Gets the intersection of the pre-selected files by the user
      data_files_default = data_files & @options[APP_OPTION_FILE_ENTRIES]
      cli_draw_empty_line
      files = @prompt.multi_select(
        "Which files do you want to unpack?",
        data_files,
        per_page: APP_VAL_ENUM_SELECT_PER_PAGE,
        default: data_files_default
      )
      cli_draw_empty_line
      if cli_confirm?("Are you sure you want to unpack the selected files?")
        start_time = Time.now
        # Unpack execution block
        begin
          files.each do |data_file|
            spinner = TTY::Spinner.new("[:spinner] Unpacking '#{data_file}'...", format: :dots)
            spinner.run do
              # TODO: Unpack data file
            end
          end
        rescue Error => e
          cli_draw_empty_line
          cli_draw_line "Unpacking failed!", :red
          cli_draw_line e.message, :red
        else
          cli_draw_empty_line
          cli_draw_line "Unpacking finished in #{Time.now - start_time} seconds", :green
        end
      else
        cli_draw_line "Cancelling the unpacking operation..."
      end
      cli_draw_empty_line
      cli_press_key_continue
    end

    def cli_submenu_pack
      cli_reset_screen
      cli_draw_info_frame(
        "Choose which external files you want to pack from the list of files below",
        "",
        "Press ↑/↓ arrows to move the cursor",
        "Use SPACE to select the current item",
        "Press CTRL + A and to select all items available",
        "You can also use CTRL + R to revert the current selection",
        "Press ENTER to finish selection"
      )
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu for setting the output path
    #
    def cli_submenu_set_output_path
      cli_reset_screen
      cli_draw_info_frame(
        "You can set the output path to the desired one below",
        "",
        "The path will be relative to the RPG Maker data folder opened",
        "",
        "Keep in mind that the app will overwrite any files inside of the output path!",
        "",
        "If left empty, the default output path (in gray) will be used",
        "",
        "If you don't want to change it, you can just press ENTER with the same path"
      )
      cli_draw_empty_line
      path = @prompt.ask(
        "Type the output path",
        value: @options[APP_OPTION_OUTPUT_PATH],
        default: APP_DEFAULT_OUTPUT_PATH
      )
      cli_draw_empty_line
      cli_draw_line "New output path obtained from input: '#{path}'"
      cli_draw_empty_line
      if cli_confirm?("Are you sure you want to update the output path?")
        @options.store(APP_OPTION_OUTPUT_PATH, path)
        cli_draw_line "Output path updated successfully!"
      else
        cli_draw_line "No changes made to the output path"
      end
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu for setting output file format
    #
    def cli_submenu_set_file_format
      cli_reset_screen
      cli_draw_info_frame(
        "You can set the type of the file format to the desired one below",
        "",
        "This option is only used when unpacking RPG Maker data into external files",
        "",
        "The default file format is automatically selected",
        "",
        "RPG Maker files will use their appropiate binary file type"
      )
      cli_draw_empty_line
      file_format = @prompt.select(
        "What type of file format should be used?",
        [
          APP_FORMAT_TYPE_YAML,
          APP_FORMAT_TYPE_JSON
        ],
        per_page: APP_VAL_SELECT_PER_PAGE,
        default: APP_DEFAULT_FORMAT_TYPE
      )
      cli_draw_empty_line
      cli_draw_line "File format type chosen: '#{file_format}'"
      cli_draw_empty_line
      if cli_confirm?("Are you sure you want to update the type of file format?")
        @options.store(APP_OPTION_FORMAT, file_format)
        cli_draw_line "Type of file format updated successfully!"
      else
        cli_draw_line "No changes made to the type of file format"
      end
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu for setting a list of file entries
    #
    def cli_submenu_set_entries
      cli_reset_screen
      cli_draw_info_frame(
        "You can set a list of file entries that will be pre-selected when performing an action",
        "",
        "Note that the changes made here will affect the list of file object IDs",
        "If a file entry is removed it will be deleted from the object ID list too",
        "",
        "You must type all entries separated by commas"
      )
      cli_draw_empty_line
      file_entries = @prompt.ask(
        "Type the list of file entries that you would like to pre-select:",
        value: @options[APP_OPTION_FILE_ENTRIES].join(","),
        default: [],
        convert: :list
      )
      # Cleans any duped entry value
      file_entries.uniq!
      cli_draw_empty_line
      cli_draw_line "List of file entries chosen: #{file_entries}"
      cli_draw_empty_line
      if cli_confirm?("Are you sure you want to update the list of file entries?")
        @options.store(APP_OPTION_FILE_ENTRIES, file_entries)
        # Since the file entries list was updated, we should drop the key-value pairs
        # from the hash of object IDs that doesn't exist in the current file entry list
        @options[APP_OPTION_IDS].delete_if do |file, _id_list|
          !file_entries.include?(file)
        end
        cli_draw_empty_line
        cli_draw_line "List of file entries updated successfully!"
        cli_draw_line "Note that the list of object IDs may have been updated consequently!"
      else
        cli_draw_line "No changes made to the list of file entries"
      end
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu for setting a list of object IDs
    #
    def cli_submenu_set_ids
      cli_reset_screen
      cli_draw_info_frame(
        "You can set a list of IDs that will be pre-selected when performing an action",
        "",
        "This is supported for all database files that contains a list of objects",
        "",
        "First, you should select all file entries which you want to set",
        "You will be asked later to set the list of IDs for each of them",
        "",
        "Press ↑/↓ arrows to move the cursor",
        "Use SPACE to select the current item",
        "Press CTRL + A and to select all items available",
        "You can also use CTRL + R to revert the current selection",
        "Press ENTER to finish selection",
        "",
        "You must type all ID values separated by commas!"
      )
      cli_draw_empty_line
      # Checks if there are some entries selected first
      current_entries = @options[APP_OPTION_FILE_ENTRIES]
      if current_entries.empty?
        cli_draw_line "There are no file entries to choose from!", :red
        cli_draw_empty_line
        cli_press_key_continue
        return
      end
      # Let user choose the list of file entries to modify
      entries = @prompt.multi_select(
        "Choose which file entries you want to set",
        current_entries,
        per_page: APP_VAL_ENUM_SELECT_PER_PAGE
      )
      # Iterate through all file entries asking the list of IDs
      entries.each do |file_entry|
        cli_draw_empty_line
        cli_draw_line "Choosing object IDs for the '#{file_entry}' file entry...", :blue
        # Gets the current list of IDs for this file entry iteration
        current_ids = @options[APP_OPTION_IDS][file_entry]
        ids = @prompt.ask(
          "Type the list of IDs that you would like to pre-select:",
          value: (current_ids || []).join(","),
          default: [],
          convert: :int_list
        )
        # Cleans any array item that is not an integer
        ids.delete_if { |id| !id.is_a?(Integer) }
        # Cleans any duped ID value
        ids.uniq!
        # Process the new list of IDs
        cli_draw_empty_line
        cli_draw_line "List of IDs chosen: #{ids}"
        cli_draw_empty_line
        if cli_confirm?("Are you sure you want to update the list of IDs?")
          if ids.empty?
            @options[APP_OPTION_IDS].delete(file_entry)
          else
            @options[APP_OPTION_IDS].store(file_entry, ids)
          end
          cli_draw_line "List of IDs for '#{file_entry}' updated successfully!", :green
        else
          cli_draw_line "No changes made to the list of IDs for '#{file_entry}'"
        end
      end
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu to show all options in a pretty format
    #
    def cli_submenu_show_options_pretty
      # Prepares rows
      rows = []
      @options.each_pair do |option_id, option_value|
        # For some reason, TTY::Table does not like hashes
        # Hence this workaround to convert it into an array
        rows << if option_value.is_a?(Hash)
                  [option_id, option_value.to_a]
                else
                  [option_id, option_value]
                end
      end
      # Screen processing
      cli_reset_screen
      cli_draw_info_frame(
        "All options will be shown below",
        "",
        "In case the table below is unreadable, use the raw format to show all options",
        "",
        "Note that not all options shown are relevant to the user"
      )
      cli_draw_empty_line
      cli_draw_table(
        ["Option ID", "Option Value"],
        *rows
      )
      cli_draw_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the submenu to show all options in a raw format
    #
    def cli_submenu_show_options_raw
      cli_reset_screen
      cli_draw_info_frame(
        "All options will be shown below",
        "",
        "Depending on the terminal screen, the pretty format can be unreadable",
        "",
        "Note that not all options shown are relevant to the user"
      )
      cli_draw_empty_line
      @options.each_pair do |option_id, option_value|
        cli_draw_line "#{option_id} => #{option_value}"
        cli_draw_empty_line
      end
      cli_draw_empty_line
      cli_press_key_continue
    end
  end
end
