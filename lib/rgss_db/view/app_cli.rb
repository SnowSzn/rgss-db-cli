# frozen_string_literal: true

require "colorize"
require "tty-screen"
require "tty-box"
require "tty-table"
require "tty-prompt"
require "tty-progressbar"
require "tty-spinner"
require_relative "../model/strings"

module RgssDb
  # Value that determines the number of options per page on the select prompt
  # @return [Integer]
  APP_CLI_SELECT_PER_PAGE = 7

  # Value that determines the number of options per page on the multi select prompt
  # @return [Integer]
  APP_CLI_MULTI_SELECT_PER_PAGE = 7

  # Value that determines the enumator character for the multi select prompt
  # @return [String]
  APP_CLI_MULTI_SELECT_ENUM_CHAR = "."

  #
  # Application CLI
  #
  class AppCli
    include Strings

    # Application version shown on the CLI
    # @return [String]
    attr_accessor :app_version

    # RPG Maker version shown on the CLI
    # @return [Symbol]
    attr_accessor :rgss_version

    # Data folder path shown on the CLI
    # @return [Symbol]
    attr_accessor :data_folder

    #
    # Creates a new app cli instance
    #
    # @param data_folder [String] RPG Maker database path
    # @param app_version [String] Application version
    # @param rgss_version [Symbol] RGSS version
    #
    def initialize(data_folder: nil, app_version: nil, rgss_version: nil)
      @app_version = app_version
      @rgss_version = rgss_version
      @data_folder = data_folder
      @prompt = TTY::Prompt.new
    end

    #
    # Resets the console screen position with a escape sequence
    #
    def reset_screen
      puts "\e[H\e[2J"
    end

    #
    # Draws all strings on the standard output
    #
    # @param strings [Array<String>] Strings
    # @param color [Symbol] Color symbol
    #
    def draw(*strings, color: nil)
      strings.each do |str|
        puts color ? str.to_s.colorize(color) : str.to_s
      end
    end

    #
    # Draws an empty line on the standard output
    #
    def draw_empty_line
      draw("")
    end

    #
    # Draws ``string`` on the standard output as info
    #
    # @param string [String] String
    #
    def draw_info(string)
      draw(string, color: :blue)
    end

    #
    # Draws ``string`` on the standard output as a warning
    #
    # @param string [String] String
    #
    def draw_warning(string)
      draw(string, color: :yellow)
    end

    #
    # Draws ``string`` on the standard output as an error
    #
    # @param string [String] String
    #
    def draw_error(string)
      draw(string, color: :red)
    end

    #
    # Draws the user's navigation in the standard output
    #
    # Nothing is drawn if the ``breadcrumbs`` array is empty
    #
    # @param breadcrumbs [Array<String>] List of breadcrumbs
    #
    def draw_navigation(*breadcrumbs)
      draw(breadcrumbs.join(" -> "), color: :blue) unless breadcrumbs.empty?
    end

    #
    # Draws a frame with the given contents on the standard output
    #
    # Nothing is drawn if the ``contents`` array is empty
    #
    # @param contents [Array<String>] Frame contents
    #
    def draw_frame(*contents)
      return if contents.empty?

      box = TTY::Box.frame(*contents)
      draw(box)
    end

    #
    # Draws an information frame with the given contents on the standard output
    #
    # Nothing is drawn if the ``contents`` array is empty
    #
    # @param contents [Array<String>] Frame contents
    #
    def draw_info_frame(*contents)
      return if contents.empty?

      box = TTY::Box.frame(
        *contents,
        title: { top_left: StrOthers::INFO_FRAME_LABEL }
      )
      draw(box)
    end

    #
    # Draws a warning frame with the given contents on the standard output
    #
    # Nothing is drawn if the ``contents`` array is empty
    #
    # @param contents [Array<String>] Frame contents
    #
    def draw_warning_frame(*contents)
      return if contents.empty?

      box = TTY::Box.frame(
        *contents,
        title: { top_left: StrOthers::WARN_FRAME_LABEL }
      )
      draw(box, color: :yellow)
    end

    #
    # Draws an error frame with the given contents on the standard output
    #
    # Nothing is drawn if the ``contents`` array is empty
    #
    # @param contents [Array<String>] Frame contents
    #
    def draw_error_frame(*contents)
      return if contents.empty?

      box = TTY::Box.frame(
        *contents,
        title: { top_left: StrOthers::ERRO_FRAME_LABEL }
      )
      draw(box, color: :red)
    end

    #
    # Draws a table on the standard output
    #
    # The number of ``columns`` and the size of each row in ``rows`` must have the same length
    #
    # Columns: [Column1, Column2]
    # Rows: [["a", "b"], ["c", "d"]]
    #
    # @param columns [Array<String>] Columns
    # @param rows [Array<String>] List of rows
    # @param render_type [Symbol] Table render type
    #
    def draw_table(columns, *rows, render_type: :unicode)
      table = TTY::Table.new(
        columns,
        rows
      )
      draw(table.render(render_type))
    end

    #
    # Draws a success operation to the terminal
    #
    # @param success_message [String] Success message
    #
    def draw_success_operation(success_message = nil)
      draw_empty_line
      draw(success_message || StrPrompts::SUCCESS_TEXT, color: :green)
      draw_empty_line
    end

    #
    # Draws a cancel operation to the terminal
    #
    # @param cancel_message [String] Cancel message
    #
    def draw_cancel_operation(cancel_message = nil)
      draw_empty_line
      draw(cancel_message || StrPrompts::CANCEL_TEXT, color: :red)
      draw_empty_line
    end

    #
    # Draws the app header on the standard output
    #
    def draw_app_header
      # App title
      draw <<~EOF
        ██████   ██████  ███████ ███████     ██████   █████  ████████  █████  ██████   █████  ███████ ███████
        ██   ██ ██       ██      ██          ██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██ ██      ██
        ██████  ██   ███ ███████ ███████     ██   ██ ███████    ██    ███████ ██████  ███████ ███████ █████
        ██   ██ ██    ██      ██      ██     ██   ██ ██   ██    ██    ██   ██ ██   ██ ██   ██      ██ ██
        ██   ██  ██████  ███████ ███████     ██████  ██   ██    ██    ██   ██ ██████  ██   ██ ███████ ███████
                                                                                                       v#{@app_version}
      EOF
        .colorize(:green)
    end

    #
    # Draws the app information on the standard output
    #
    def draw_app_info
      # Data folder
      draw(format(StrAppInfo::DATA_FOLDER, @data_folder), color: :green)
      # Detected RGSS version
      draw(format(StrAppInfo::RPG_VERSION, @rgss_version || StrAppInfo::VERSION_INVALID_LABEL), color: :green)

      # Draw warning frame in case rpg maker version is unknown
      return unless @rgss_version.nil?

      draw_empty_line
      draw_warning_frame(StrAppInfo::VERSION_INVALID_TEXT)
    end

    #
    # Draws a menu header on the terminal
    #
    # This header is common for every application menu
    #
    # @param menu_contents [Array<String>] Menu information contents
    # @param breadcrumbs [Array<String>] Breadcrumbs list
    #
    def draw_app_menu(*menu_contents, breadcrumbs: nil)
      reset_screen
      draw_app_header
      draw_empty_line
      draw_app_info
      draw_empty_line

      # Draw breadcrumbs on screen
      unless breadcrumbs.nil?
        draw_navigation(*breadcrumbs)
        draw_empty_line
      end

      # Draw information panel on screen
      return if menu_contents.empty?

      draw_info_frame(*menu_contents)
      draw_empty_line
    end

    #
    # Draws a submenu header on the terminal
    #
    # This header is common for every application submenu
    #
    # @param menu_contents [Array<String>] Menu information contents
    # @param breadcrumbs [Array<String>] Breadcrumbs list
    #
    def draw_app_submenu(*menu_contents, breadcrumbs: nil)
      reset_screen

      # Draw breadcrumbs on screen
      unless breadcrumbs.nil?
        draw_navigation(*breadcrumbs)
        draw_empty_line
      end

      # Draw menu contents on screen
      return if menu_contents.empty?

      draw_info_frame(*menu_contents)
      draw_empty_line
    end

    #
    # Executes and draws a terminal pause to the standard output
    #
    # If ``timeout`` is given, the execution will be resumed after that time
    #
    # @param keys [Array<Symbol>] List of key symbols
    # @param timeout [Integer] Time out in seconds
    #
    def prompt_pause(*keys, timeout: nil)
      if keys.empty?
        # No specific keys
        if timeout
          @prompt.keypress(
            StrPrompts::PAUSE_ANY_KEYS_TIMEOUT.colorize(:green),
            timeout: timeout
          )
        else
          @prompt.keypress(
            StrPrompts::PAUSE_ANY_KEYS.colorize(:green)
          )
        end
      else
        # Specific keys
        key_names = keys.map { |key| key.to_s.upcase }.join(", ")
        if timeout
          @prompt.keypress(
            format(StrPrompts::PAUSE_KEYS_TIMEOUT, key_names).colorize(:green),
            keys: keys,
            timeout: timeout
          )
        else
          @prompt.keypress(
            format(StrPrompts::PAUSE_KEYS, key_names).colorize(:green),
            keys: keys
          )
        end
      end
    end

    #
    # Executes and draws an user confirmation on the standard output
    #
    # @param input_text [String] Menu text
    # @param default [Boolean] Default option
    #
    # @return [Boolean]
    #
    def prompt_confirm?(input_text = nil, default: true)
      @prompt.yes?(input_text || StrPrompts::CONFIRM_INPUT_TEXT, default: default)
    end

    #
    # Executes and draws an user input on the standard output
    #
    # @param question [String] Question to ask
    # @param default [String] Default option
    # @param value [String] Pre-populated value
    # @param required [Boolean] Force input
    # @param convert [Symbol] Conversion symbol
    # @param validate_text [String] Validation fail text
    # @param validate [Proc] Validation callback
    #
    # @yieldparam [String]
    #
    # @return [String]
    #
    def prompt_ask(question, default: nil, value: nil, required: false, convert: nil, validate_text: nil, &validate)
      @prompt.ask(
        question,
        default: default,
        value: value,
        required: required,
        convert: convert || :string
      ) do |ask|
        ask.validate ->(input) { yield input }, validate_text || StrPrompts::ASK_VALIDATION_FAIL_TEXT if block_given?
      end
    end

    #
    # Executes and draws a menu selection on the standard output+
    #
    # If ``menu_cycle`` is true, the selection will cycle around if the top/bottom option is reached
    #
    # @param menu_options [Array] List of menu options
    # @param default [Array] Default options
    # @param input_text [String] Menu text
    # @param menu_cycle [Boolean] Menu cycle status
    #
    # @return [String] Selected option
    #
    def prompt_select(*menu_options, default: nil, input_text: nil, menu_cycle: false)
      @prompt.select(
        input_text || StrPrompts::SELECT_INPUT_TEXT,
        menu_options,
        default: default,
        cycle: menu_cycle,
        per_page: APP_CLI_SELECT_PER_PAGE
      )
    end

    #
    # Executes and draws a menu selection on the standard output+
    #
    # If ``menu_cycle`` is true, the selection will cycle around if the top/bottom option is reached
    #
    # @param menu_options [Array] List of menu options
    # @param default [Array] Default options
    # @param input_text [String] Menu text
    # @param menu_cycle [Boolean] Menu cycle status
    #
    # @return Selected options
    #
    def prompt_select_multi(*menu_options, default: nil, input_text: nil, menu_cycle: false)
      @prompt.multi_select(
        input_text || StrPrompts::SELECT_INPUT_TEXT,
        menu_options,
        default: default,
        cycle: menu_cycle,
        per_page: APP_CLI_MULTI_SELECT_PER_PAGE,
        enum: APP_CLI_MULTI_SELECT_ENUM_CHAR
      )
    end

    #
    # Executes and draws a spinner with a routine on the standard output
    #
    # This method allows to execute a block while a spinner is drawn on the screen
    #
    # @param text [String] Spinner text
    # @param block [Proc]
    # @yieldparam spinner [TTY::Spinner]
    #
    def prompt_spinner(text, &block)
      spinner = TTY::Spinner.new("[:spinner] #{text}", format: :dots)
      spinner.run(StrPrompts::SPINNER_TASK_COMPLETED_TEXT) { yield spinner }
    end
  end
end
