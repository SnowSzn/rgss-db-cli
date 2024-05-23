# frozen_string_literal: true

require_relative "./version"
require_relative "./model/errors"
require_relative "./model/debug"
require_relative "./model/strings"
require_relative "./model/utilities"
require_relative "./view/app_cli"
require_relative "./controller/data_manager"

module RgssDb
  # App option debug mode
  APP_OPTION_DEBUG_MODE = :debug

  # App option back up flag
  APP_OPTION_BACK_UP = :backup

  # App option action type
  APP_OPTION_ACTION = :action

  # App option file entries
  APP_OPTION_FILE_ENTRIES = :files

  # App option object ids
  APP_OPTION_IDS = :ids

  # App option format
  APP_OPTION_FORMAT_TYPE = :type

  # App option working directory
  APP_OPTION_WORKING_DIR = :directory

  # Export data action command name
  #
  # This action unpacks and exports all binary files into external files
  APP_ACTION_EXPORT = "export"

  # Import data action command name
  #
  # This action packs and imports external files into binary files
  APP_ACTION_IMPORT = "import"

  # Default back up mode of the application
  APP_DEFAULT_BACK_UP = true

  # Default debug mode of the application
  APP_DEFAULT_DEBUG_MODE = 0

  # Default file format type for the application
  APP_DEFAULT_FORMAT_TYPE = "YAML"

  # Default working directory for the application
  APP_DEFAULT_WORKING_DIR = "./rgss-db"

  #
  # Application class
  #
  class App
    include Strings

    #
    # Creates a new app instance
    #
    # @param data_path [String] RPG Maker database folder
    # @param options [Hash<Symbol, Object>] App options hash
    #
    def initialize(data_path, options)
      @options = process_options(options)
      @data_manager = DataManager.new(data_path)
      @cli = AppCli.new(
        data_folder: @data_manager.path,
        rgss_version: @data_manager.rgss_version,
        app_version: RgssDb::VERSION
      )
    end

    #
    # Starts the app
    #
    def start
      # Checks for debug usage to start the module or not
      unless Debug.disabled?
        debug_path = File.expand_path(opt_working_dir, @data_manager.path)
        Debug.start(debug_path)
        Debug.update_extra_info(@data_manager.path, @data_manager.rgss_version)
        Debug.write_debug_header
      end

      # Start application logic
      begin
        if opt_action
          # An action was given, avoid main menu loop
          Debug.log_info("bypassing app menu")

          # Creates the data files instances
          data_files = []
          case opt_action
          when APP_ACTION_EXPORT
            data_files = @data_manager.load_database_files

            # Checks if user selected specific file entries
            unless opt_file_entries.empty?
              data_files = data_files.keep_if do |data_file|
                opt_file_entries.any? { |entry| data_file.file?(entry) }
              end
            end

            # Applies any possible object IDs list for each file entry
            data_files.each do |data_file|
              data_file.object_ids_update(*opt_file_object_ids(data_file.file))
            end
          when APP_ACTION_IMPORT
            data_files = @data_manager.load_extracted_files(opt_working_dir)

            # Checks if user selected specific file entries
            unless opt_file_entries.empty?
              data_files = data_files.keep_if do |data_file|
                opt_file_entries.any? { |entry| data_file.file?(entry) }
              end
            end
          end

          # Perform the action for each data file created
          data_files.each { |data_file| do_action(opt_action, data_file) }
        else
          # No action given, run the app main menu loop
          Debug.log_info("running app menu")
          menu_main
        end
      rescue Error => e
        # Application error
        Debug.log_exception(e, @options)
        @cli.draw_empty_line
        @cli.draw_error(e.message)
        @cli.draw_empty_line
        @cli.prompt_pause
        retry
      rescue StandardError => e
        # Unknown error
        Debug.log_exception(e, @options)
      end
    end

    private

    #
    # Process the user options
    #
    # @param options_hash [Hash<Symbol, Object>] Options hash
    #
    # @return [Hash<Symbol, Object>]
    #
    def process_options(options_hash)
      options = {}
      options_hash.each_pair do |option_id, option_value|
        case option_id
        when APP_OPTION_DEBUG_MODE
          # Process the debug mode
          debug_mode_id = option_value.to_s.to_i # to 0 if invalid int
          options.store(option_id, debug_mode_id)
          Debug.update_debug_mode(debug_mode_id)
        when APP_OPTION_ACTION
          # Process the action option (case insensitive)
          action = option_value.to_s
          if action.casecmp?(APP_ACTION_IMPORT)
            options.store(option_id, APP_ACTION_IMPORT)
          elsif action.casecmp?(APP_ACTION_EXPORT)
            options.store(option_id, APP_ACTION_EXPORT)
          else
            # Unknown action value
            options.store(option_id, nil)
          end
        when APP_OPTION_FORMAT_TYPE
          # Process the output file format option (case insensitive)
          type = option_value.to_s.downcase.to_sym
          case type
          when RGSS_FORMAT_TYPE_BINARY
            options.store(option_id, RGSS_FORMAT_TYPE_BINARY)
          when RGSS_FORMAT_TYPE_JSON
            options.store(option_id, RGSS_FORMAT_TYPE_JSON)
          when RGSS_FORMAT_TYPE_YAML
            options.store(option_id, RGSS_FORMAT_TYPE_YAML)
          else
            options.store(option_id, APP_DEFAULT_FORMAT_TYPE)
          end
        when APP_OPTION_WORKING_DIR
          # Process the working directory option
          path = Utilities.valid_path?(option_value) ? option_value : APP_DEFAULT_WORKING_DIR
          options.store(option_id, path)
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
    # Gets the user's backup flag
    #
    # @return [Boolean]
    #
    def opt_backup_allowed
      @options[APP_OPTION_BACK_UP]
    end

    #
    # Gets the user's action option
    #
    # @return [Symbol]
    #
    def opt_action
      @options[APP_OPTION_ACTION]
    end

    #
    # Gets the user's file format type option
    #
    # @return [String]
    #
    def opt_format_type
      @options[APP_OPTION_FORMAT_TYPE]
    end

    #
    # Gets the user's working directory option
    #
    # @return [String]
    #
    def opt_working_dir
      @options[APP_OPTION_WORKING_DIR]
    end

    #
    # Gets the user's file entries option
    #
    # @return [Array<String>]
    #
    def opt_file_entries
      @options[APP_OPTION_FILE_ENTRIES]
    end

    #
    # Gets the user's hash of object IDs and file entries
    #
    # @return [Hash<String, Array<Integer>>]
    #
    def opt_object_ids
      @options[APP_OPTION_IDS]
    end

    #
    # Gets the user's object IDs option
    #
    # @param file_name [String] File entry
    #
    # @return [Array<Integer>]
    #
    def opt_file_object_ids(file_name)
      @options[APP_OPTION_IDS][file_name] || []
    end

    #
    # Performs the action by ``action_name`` with the given data file
    #
    # @param action_name [String] Action
    # @param data_file [DataFile] Data file
    #
    # @raise [StandardError]
    #
    def do_action(action_name, data_file)
      case action_name
      when APP_ACTION_EXPORT
        Debug.log_info("exporting: #{data_file}")
        @data_manager.save_data_file(data_file, opt_working_dir, opt_format_type)
        Debug.log_info("exporting action finished!")
      when APP_ACTION_IMPORT
        Debug.log_info("importing: #{data_file}")

        # Checks if the data file is a "full file" to avoid data loss, this error
        # should never trigger since data_file should have all objects selected
        # at this point for import (hardcoded), but it exists as a security measure
        raise "trying to import an incompleted data file: #{data_file.inspect}" unless data_file.all_objects?

        # Performs a back up creation (if allowed)
        if opt_backup_allowed
          Debug.log_info("creating back up file...")
          @data_manager.save_database_back_up(data_file.file, opt_working_dir)
          Debug.log_info("back up created")
        else
          Debug.log_info("back up creation is disabled!")
        end

        # Performs the import process
        @data_manager.save_data_file(data_file, @data_manager.path, RGSS_FORMAT_TYPE_BINARY)
        Debug.log_info("importing action finished!")
      else
        raise "action called with an unknown action name: '#{action_name}'"
      end
    end

    #
    # Main menu process
    #
    def menu_main
      loop do
        @cli.draw_app_menu(
          StrMenuContents::APP_MENU_MAIN_MENU_TEXT_INFO,
          breadcrumbs: [StrMenu::APP_MENU_MAIN_MENU]
        )
        option = @cli.prompt_select(
          StrMenu::APP_MENU_ACTIONS,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_EXIT
        )
        case option
        when StrMenu::APP_MENU_ACTIONS
          menu_actions
        when StrMenu::APP_MENU_OPTIONS
          menu_options
        when StrMenu::APP_MENU_EXIT
          submenu_exit
          break
        end
      end
    end

    #
    # Perform actions menu process
    #
    def menu_actions
      loop do
        @cli.draw_app_menu(
          StrMenuContents::APP_MENU_ACTIONS_TEXT_INFO,
          breadcrumbs: [StrMenu::APP_MENU_MAIN_MENU, StrMenu::APP_MENU_ACTIONS]
        )
        option = @cli.prompt_select(
          StrMenu::APP_MENU_ACTIONS_EXPORT,
          StrMenu::APP_MENU_ACTIONS_IMPORT,
          StrMenu::APP_MENU_EXIT
        )
        case option
        when StrMenu::APP_MENU_ACTIONS_EXPORT
          submenu_export
        when StrMenu::APP_MENU_ACTIONS_IMPORT
          submenu_import
        when StrMenu::APP_MENU_EXIT
          submenu_exit
          break
        end
      end
    end

    #
    # Options menu process
    #
    def menu_options
      loop do
        @cli.draw_app_menu(
          StrMenuContents::APP_MENU_OPTIONS_TEXT_INFO,
          breadcrumbs: [StrMenu::APP_MENU_MAIN_MENU, StrMenu::APP_MENU_OPTIONS]
        )
        option = @cli.prompt_select(
          StrMenu::APP_MENU_OPTIONS_SET_FORMAT_TYPE,
          StrMenu::APP_MENU_OPTIONS_SET_WORKING_DIR,
          StrMenu::APP_MENU_OPTIONS_SET_ENTRIES,
          StrMenu::APP_MENU_OPTIONS_SET_IDS,
          StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY,
          StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_RAW,
          StrMenu::APP_MENU_EXIT
        )
        case option
        when StrMenu::APP_MENU_OPTIONS_SET_FORMAT_TYPE
          submenu_set_format_type
        when StrMenu::APP_MENU_OPTIONS_SET_WORKING_DIR
          submenu_set_working_dir
        when StrMenu::APP_MENU_OPTIONS_SET_ENTRIES
          submenu_set_entries
        when StrMenu::APP_MENU_OPTIONS_SET_IDS
          submenu_set_ids
        when StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY
          submenu_show_options_pretty
        when StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_RAW
          submenu_show_options_raw
        when StrMenu::APP_MENU_EXIT
          submenu_exit
          break
        end
      end
    end

    #
    # Exit submenu process
    #
    def submenu_exit
      @cli.draw_cancel_operation(StrSubMenu::EXIT_TEXT)
    end

    #
    # Export submenu process
    #
    # @raise [Error]
    #
    def submenu_export
      @cli.draw_app_submenu(
        StrSubMenu::EXPORT_TEXT, StrPrompts::MULTI_SELECT_TIP_TEXT,
        breadcrumbs: [StrMenu::APP_MENU_MAIN_MENU, StrMenu::APP_MENU_ACTIONS, StrMenu::APP_MENU_ACTIONS_EXPORT]
      )

      data_files = []
      @cli.prompt_spinner(StrSubMenu::EXPORT_LOAD_FILES_TEXT) do
        data_files = @data_manager.load_database_files
      end
      raise Error, StrSubMenu::EXPORT_LOAD_ERROR_TEXT if data_files.empty?

      # Determines the list of pre-selected database files (for TTY select menu)
      data_files_default = Utilities.menu_default_indexes(
        data_files,
        opt_file_entries,
        all_if_empty: true
      ) do |menu_option, menu_index, file_entry|
        menu_option.file?(file_entry)
      end

      # Ask the user to select the data files
      # @type [Array<DataFile>]
      data_files_selected = @cli.prompt_select_multi(
        *data_files, default: data_files_default
      )
      raise Error, StrSubMenu::EXPORT_NO_FILES_ERROR_TEXT if data_files_selected.empty?

      # Determine the list of object IDs for each data file that supports it
      data_files_selected.each do |data_file|
        data_file_list = data_file.to_list
        next if data_file_list.nil?
        next unless @cli.prompt_confirm?(
          format(StrSubMenu::EXPORT_SELECT_OBJ_FROM_FILE_TEXT, data_file),
          default: false
        )

        data_file_list_default = Utilities.menu_default_indexes(
          data_file_list,
          opt_file_object_ids(data_file.file)
        )
        data_file_list_selected = @cli.prompt_select_multi(
          *data_file_list,
          default: data_file_list_default
        )
        data_file.object_ids_update(data_file.convert_list_to_ids(data_file_list_selected))
      end

      # Confirm operation
      unless @cli.prompt_confirm?
        @cli.draw_cancel_operation
        @cli.prompt_pause
        return
      end

      # Perform operation
      data_files_selected.each do |data_file|
        @cli.prompt_spinner(format(StrSubMenu::EXPORT_ACTION_TEXT, data_file)) do
          do_action(APP_ACTION_EXPORT, data_file)
        end
      end

      @cli.draw_success_operation
      @cli.prompt_pause
    end

    #
    # Import submenu process
    #
    # @raise [Error]
    #
    def submenu_import
      @cli.draw_app_submenu(
        StrSubMenu::IMPORT_TEXT, StrPrompts::MULTI_SELECT_TIP_TEXT,
        breadcrumbs: [StrMenu::APP_MENU_MAIN_MENU, StrMenu::APP_MENU_ACTIONS, StrMenu::APP_MENU_ACTIONS_IMPORT]
      )

      data_files = []
      @cli.prompt_spinner(StrSubMenu::IMPORT_LOAD_FILES_TEXT) do
        data_files = @data_manager.load_extracted_files(opt_working_dir)
      end
      raise Error, StrSubMenu::IMPORT_LOAD_ERROR_TEXT if data_files.empty?

      # Determines the list of pre-selected files (for TTY select menu)
      data_files_default = Utilities.menu_default_indexes(
        data_files,
        opt_file_entries,
        all_if_empty: true
      ) do |menu_option, menu_index, file_entry|
        menu_option.file?(file_entry)
      end

      # Ask the user to select the data files
      # @type [Array<DataFile>]
      data_files_selected = @cli.prompt_select_multi(
        *data_files, default: data_files_default
      )
      raise Error, StrSubMenu::IMPORT_NO_FILES_ERROR_TEXT if data_files_selected.empty?

      # Confirm operation
      unless @cli.prompt_confirm?
        @cli.draw_cancel_operation
        @cli.prompt_pause
        return
      end

      # Perform operation
      data_files_selected.each do |data_file|
        @cli.prompt_spinner(format(StrSubMenu::IMPORT_ACTION_TEXT, data_file)) do
          do_action(APP_ACTION_IMPORT, data_file)
        end
      end

      @cli.draw_success_operation
      @cli.prompt_pause
    end

    #
    # Set file format type submenu process
    #
    def submenu_set_format_type
      @cli.draw_app_submenu(
        StrSubMenu::SET_FORMAT_TYPE_TEXT, StrPrompts::SELECT_TIP_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SET_FORMAT_TYPE
        ]
      )

      # Ask user to select a file format
      file_format = @cli.prompt_select(
        RGSS_FORMAT_TYPE_YAML,
        RGSS_FORMAT_TYPE_JSON,
        RGSS_FORMAT_TYPE_BINARY
      )

      # Confirm operation
      if @cli.prompt_confirm?
        @options.store(APP_OPTION_FORMAT_TYPE, file_format)
        @cli.draw_success_operation(format(StrSubMenu::SET_FORMAT_TYPE_UPDATE_TEXT, file_format))
      else
        @cli.draw_cancel_operation
      end
      @cli.prompt_pause
    end

    #
    # Set working directory submenu process
    #
    def submenu_set_working_dir
      @cli.draw_app_submenu(
        StrSubMenu::SET_WORKING_DIR_TEXT, StrPrompts::ASK_TIP_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SET_WORKING_DIR
        ]
      )

      # Ask user to type the new app working dir
      working_dir = @cli.prompt_ask(
        StrSubMenu::SET_WORKING_DIR_ASK_TEXT,
        default: APP_DEFAULT_WORKING_DIR,
        value: opt_working_dir,
        validate_text: StrSubMenu::SET_WORKING_DIR_ASK_FAIL_TEXT
      ) do |input|
        Utilities.valid_path?(input)
      end

      # Confirm operation
      if @cli.prompt_confirm?
        @options.store(APP_OPTION_WORKING_DIR, working_dir)
        @cli.draw_success_operation(format(StrSubMenu::SET_WORKING_DIR_UPDATE_TEXT, working_dir))
      else
        @cli.draw_cancel_operation
      end
      @cli.prompt_pause
    end

    #
    # Set pre-selected file entries submenu process
    #
    def submenu_set_entries
      @cli.draw_app_submenu(
        StrSubMenu::SET_ENTRIES_TEXT, StrPrompts::ASK_TIP_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SET_ENTRIES
        ]
      )

      # Ask user to type the list of entries
      # @type [Array<String>]
      entries = @cli.prompt_ask(
        StrSubMenu::SET_ENTRIES_ASK_TEXT,
        default: [],
        value: opt_file_entries.join(","),
        convert: :list
      )

      # Confirm operation
      if @cli.prompt_confirm?
        entries.uniq! # Make the entries unique before saving it
        @options.store(APP_OPTION_FILE_ENTRIES, entries)
        @cli.draw_success_operation(format(StrSubMenu::SET_ENTRIES_UPDATE_TEXT, entries))

        # Since the file entries list was updated, we should drop the key-value pairs
        # from the hash of object IDs that doesn't exist in the current file entry list
        @options[APP_OPTION_IDS].delete_if do |file_entry, ids_array|
          !entries.include?(file_entry)
        end
      else
        @cli.draw_cancel_operation
      end
      @cli.prompt_pause
    end

    #
    # Set pre-selected object IDs submenu process
    #
    # @raise [Error]
    #
    def submenu_set_ids
      @cli.draw_app_submenu(
        StrSubMenu::SET_IDS_TEXT, StrPrompts::MULTI_SELECT_TIP_TEXT, StrPrompts::ASK_TIP_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SET_IDS
        ]
      )

      # Checks if the user's file entries list is empty
      raise Error, StrSubMenu::SET_IDS_NO_FILES_ERROR_TEXT if opt_file_entries.empty?

      # Ask user to type the list of entries
      # @type [Array<String>]
      entries = @cli.prompt_select_multi(
        *opt_file_entries
      )
      raise Error, StrSubMenu::SET_IDS_NO_FILES_SELECTED_ERROR_TEXT if entries.empty?

      # @type [Hash<String, Array<Integer>>]
      ids = opt_object_ids

      # Ask the user for the list of object IDs for each file entry selected
      entries.each do |file_entry|
        current_ids = opt_file_object_ids(file_entry)
        # @type [Array<Integer>]
        user_ids = @cli.prompt_ask(
          format(StrSubMenu::SET_IDS_ASK_IDS_TEXT, file_entry),
          default: [],
          value: current_ids.join(","),
          convert: :int_list
        )
        # Process the user input
        if user_ids.empty?
          # Deletes the file entry if the list of IDs is empty
          ids.delete(file_entry)
        else
          # Cleans any item that is not an integer
          user_ids.delete_if { |id| !id.is_a?(Integer) }
          # Removes any dupes
          user_ids.uniq!
          # Saves the list of IDs
          ids.store(file_entry, user_ids)
        end
      end

      # Confirm operation
      if @cli.prompt_confirm?
        @options.store(APP_OPTION_IDS, ids)
        @cli.draw_success_operation(format(StrSubMenu::SET_IDS_UPDATE_TEXT, ids))
      else
        @cli.draw_cancel_operation
      end
      @cli.prompt_pause
    end

    #
    # Show app options (pretty) submenu process
    #
    def submenu_show_options_pretty
      @cli.draw_app_submenu(
        StrSubMenu::SHOW_OPTIONS_PRETTY_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY
        ]
      )

      # Prepares the table rows
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

      # Shows the option in a table
      @cli.draw_table(
        [StrSubMenu::SHOW_OPTIONS_COLUMN_1, StrSubMenu::SHOW_OPTIONS_COLUMN_2],
        *rows
      )
      @cli.draw_success_operation
      @cli.prompt_pause
    end

    #
    # Show app options (raw) submenu process
    #
    def submenu_show_options_raw
      @cli.draw_app_submenu(
        StrSubMenu::SHOW_OPTIONS_RAW_TEXT,
        breadcrumbs: [
          StrMenu::APP_MENU_MAIN_MENU,
          StrMenu::APP_MENU_OPTIONS,
          StrMenu::APP_MENU_OPTIONS_SHOW_OPTIONS_RAW
        ]
      )

      @options.each_pair do |option_id, option_value|
        @cli.draw("#{option_id} => #{option_value}")
      end
      @cli.draw_success_operation
      @cli.prompt_pause
    end
  end
end
