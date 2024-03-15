# frozen_string_literal: true

require "colorize"
require "tty-screen"
require "tty-box"
require "tty-table"
require "tty-prompt"
require "tty-progressbar"
require "tty-spinner"
require_relative "./version"
require_relative "./errors/errors"
require_relative "./process/data_manager"

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

  # Default output path for the application
  APP_OUTPUT_PATH = "./rgss-db"

  # Default format type of the application
  APP_FORMAT_TYPE = "yaml"

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

  # App menu option for unpacking command
  APP_MENU_CMD_ACTION_UNPACK = "Unpack RPG Maker Data"

  # App menu option for packing command
  APP_MENU_CMD_ACTION_PACK = "Pack External Data into RPG Maker Files"

  # App menu option to set the output path
  APP_MENU_CMD_SET_OUTPUT_PATH = "Set Output Path"

  # App menu option to set the output file format type
  APP_MENU_CMD_SET_FORMAT = "Set Type of File Format"

  # App menu option to show the values of the current options
  APP_MENU_CMD_SHOW_OPTIONS = "Show Options"

  # App menu option for exiting command
  APP_MENU_CMD_EXIT = "Exit"

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
      @data_manager = DataManager.new(data_path)
      @options = options
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
      option_action = option_value(APP_OPTION_ACTION)
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
    # Gets the value of the option ``option_id``
    #
    # The value is only returned if supported, otherwise it is ``nil``
    #
    # @param [Symbol] option_id App option ID
    #
    # @return [Object]
    #
    def option_value(option_id)
      option_value = @options[option_id]
      case option_id
      when APP_OPTION_ACTION
        # Process the action option
        return APP_CMD_ACTION_PACK if option_value.to_s.casecmp?(APP_CMD_ACTION_PACK)
        return APP_CMD_ACTION_UNPACK if option_value.to_s.casecmp?(APP_CMD_ACTION_UNPACK)

        nil
      when APP_OPTION_FILE_ENTRIES
        # Process the file entries option
        option_value
      when APP_OPTION_IDS
        # Process the IDs option
        option_value
      when APP_OPTION_FORMAT
        # Process the format option
        return APP_FORMAT_TYPE_JSON if option_value.to_s.casecmp?(APP_FORMAT_TYPE_JSON)
        return APP_FORMAT_TYPE_YAML if option_value.to_s.casecmp?(APP_FORMAT_TYPE_YAML)

        nil
      when APP_OPTION_OUTPUT_PATH
        # Process the output path option
        option_value
      end
    end

    #
    # Draws an empty line on the standard output
    #
    def cli_empty_line
      puts ""
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
        key_names = keys.map { |key| key.to_s.upcase }.join(", ")
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
        title: { top_left: "Information", bottom_right: site }
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
        title: { top_left: "Warning", bottom_right: site }
      )
      puts box.colorize(:yellow)
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
      # opened data folder
      puts "RPG Maker Data folder: #{@data_manager.path}".colorize(:green)
      # Detected RGSS version
      puts "RPG Maker version: #{@data_manager.rgss_version}".colorize(:green)
      # warning panel
      cli_empty_line
      if @data_manager.version_unknown?
        cli_draw_warning_frame(
          "It was not possible to detect a valid RPG Maker version in the given directory!",
          "",
          "The detected version of RPG Maker determines which type of database is imported",
          "",
          "If the version is unknown, it means that the RPG Maker version could not be resolved, either because",
          "there are no database files in the given path or because there are files from two versions of the engine",
          "(such as Items.rvdata2 and Map001.rxdata), therefore the correct RPG Maker version cannot be determined",
          "",
          "This is because the app cannot work with different versions of RPG Maker data files at the same time",
          "",
          "Some database classes have the same name but different definitions, which could result in data corruption",
          "",
          "You should exit and fix the problems before interacting further with the database"
        )
      else
        cli_draw_info_frame(
          "A valid RPG Maker version was detected in the given directory",
          "",
          "All database classes for '#{@data_manager.rgss_version}' has been loaded!"
        )
      end
    end

    #
    # Draws and runs the main menu selection process
    #
    def cli_menu_main
      loop do
        cli_reset_screen
        cli_draw_header
        cli_empty_line
        option = @prompt.select(
          "What would you like to do?",
          [
            APP_MENU_CMD_ACTION_PACK,
            APP_MENU_CMD_ACTION_UNPACK,
            APP_MENU_CMD_SET_FORMAT,
            APP_MENU_CMD_SET_OUTPUT_PATH,
            APP_MENU_CMD_SHOW_OPTIONS,
            APP_MENU_CMD_EXIT
          ]
        )
        case option
        when APP_MENU_CMD_ACTION_PACK
          cli_menu_pack
        when APP_MENU_CMD_ACTION_UNPACK
          cli_menu_unpack
        when APP_MENU_CMD_SET_OUTPUT_PATH
          cli_menu_set_output_path
        when APP_MENU_CMD_SET_FORMAT
          cli_menu_set_file_format
        when APP_MENU_CMD_SHOW_OPTIONS
          cli_menu_show_options
        when APP_MENU_CMD_EXIT
          print "Exiting...".colorize(:red)
          break
        end
      end
      # bar = TTY::ProgressBar.new("Unpacking data... [:bar] :percent (ETA::eta)", total: 30)
      # 30.times do
      #   sleep(0.1)
      #   bar.advance # by default increases by 1
      # end
      # spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
      # spinner.auto_spin # Automatic animation with default interval
      # sleep(2) # Perform task
      # spinner.stop("Done!") # Stop animation
    end

    def cli_menu_unpack
      cli_reset_screen
      cli_draw_info_frame(
        "Choose which data files you want to unpack from the list of files below",
        "",
        "Press ↑/↓ arrows to move the cursor",
        "",
        "Use SPACE to select the current item",
        "",
        "Press CTRL + A and to select all items available",
        "",
        "You can also use CTRL + R to revert the current selection",
        "",
        "Press ENTER to finish selection",
        site: APP_MENU_CMD_ACTION_UNPACK
      )
      cli_empty_line
      files = @prompt.multi_select("Which files do you want to unpack?", %w[1 2 3 4 5 6])
      p "files selected: #{files}"
      @data_manager.unpack("test", [], [], "yaml")
    end

    def cli_menu_pack
      @data_manager.pack("test", [], [])
    end

    #
    # Draws and runs the menu for the set output path command
    #
    def cli_menu_set_output_path
      cli_reset_screen
      cli_draw_info_frame(
        "You can set the output path to the desired one below",
        "",
        "Keep in mind that the app will overwrite any files inside of the output path!",
        "",
        "If left empty, the current path (in gray) will be used",
        "",
        "The default output path is: '#{APP_OUTPUT_PATH}'",
        "",
        "If you don't want to change it, you can just press ENTER with the same path",
        site: APP_MENU_CMD_SET_OUTPUT_PATH
      )
      cli_empty_line
      path = @prompt.ask("Type the output path:", default: option_value(APP_OPTION_OUTPUT_PATH))
      cli_empty_line
      puts "New output path obtained from input: '#{path}'"
      cli_empty_line
      if cli_confirm?("Are you sure you want to update the output path?")
        @options.store(APP_OPTION_OUTPUT_PATH, path)
        puts "Output path updated successfully!"
      else
        puts "No changes made to the output path"
      end
      cli_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the set output file format process
    #
    def cli_menu_set_file_format
      cli_reset_screen
      cli_draw_info_frame(
        "You can set the type of the file format to the desired one below",
        "",
        "This option is only used when unpacking RPG Maker data into external files",
        "",
        "The default file format is: '#{APP_FORMAT_TYPE}'",
        "",
        "RPG Maker files will use their appropiate binary file type",
        site: APP_MENU_CMD_SET_FORMAT
      )
      cli_empty_line
      file_format = @prompt.select(
        "What type of file format should be used?",
        [
          APP_FORMAT_TYPE_JSON,
          APP_FORMAT_TYPE_YAML
        ]
      )
      cli_empty_line
      puts "File format type chosen: '#{file_format}'"
      cli_empty_line
      if cli_confirm?("Are you sure you want to update the type of file format?")
        @options.store(APP_OPTION_FORMAT, file_format)
        puts "Type of file format updated successfully!"
      else
        puts "No changes made to the type of file format"
      end
      cli_empty_line
      cli_press_key_continue
    end

    #
    # Draws and runs the menu to show all app options
    #
    def cli_menu_show_options
      cli_reset_screen
      cli_draw_info_frame(
        "All options will be shown in the table below",
        "",
        "Not all options shown are relevant to the user",
        site: APP_MENU_CMD_SHOW_OPTIONS
      )
      cli_empty_line
      table = TTY::Table.new(
        ["Option ID", "Option Value"],
        @options.to_a
      )
      puts table.render(:unicode)
      cli_empty_line
      cli_press_key_continue
    end
  end
end
