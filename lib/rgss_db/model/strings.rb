# frozen_string_literal: true

module RgssDb
  #
  # Application strings module
  #
  module Strings
    #
    # Application information CLI strings
    #
    module StrAppEntryPoint
      # Message shown when the app call is invalid
      CLI_INVALID_CALL_MSG = <<~INVALID_CALL
        Please provide a RPG Maker database directory!
        Use 'rgss-db --help' to get more information
      INVALID_CALL

      # App version message
      #
      # String contains a "%s" flag to insert the app version
      CLI_VERSION = "rgss-db version %s installed"

      # App banner contents
      CLI_BANNER = <<~BANNER
        SYNOPSIS
          rgss-db is a tool for developers to export and/or import the database files of a game made in RPG Maker

          This tool works on any RPG Maker editor based on RGSS:
            - RPG Maker XP
            - RPG Maker VX
            - RPG Maker VX Ace

        USAGE
        rgss-db data_directory [options]

        DESCRIPTION
          You can simply use this tool by calling the rgss-db command and supplying a RPG Maker data path:
            # Opens the current directory
            rgss-db .

          The path needs to be the data folder where all binary database files are stored, otherwise the app won't work

          This will open the application's menu where you can manually perform the desired action.

          The application has a number of options that allow you to customize the behavior and output, for example:
            # You can set the application's debug mode with the following option
            # A log file will be created inside the application's working directory
            rgss-db . --debug 0 # Disables debug functionality (default)
            rgss-db . --debug 1 # Enables debug error level
            rgss-db . --debug 2 # Enables debug warning level
            rgss-db . --debug 3 # Enables debug info level

            # You can disable the automatic backup creation with the flag
            rgss-db . --no-backup

            # Sets the application's working directory (used for exporting and importing)
            rgss-db . -d "./custom_path/from/the data folder"

            # Sets the application's file format (used for exporting and importing)
            rgss-db . -t json
            rgss-db . -t yaml
            rgss-db . -t binary # Auto. selects the appropiate binary format

            # Sets a list of data files that will be affected by the action
            # If not provided, it will consider all data files
            rgss-db . -f Items.rvdata2 Weapons.rvdata2 Map001.rvdata2 # Selects "Items", "Weapons" and "Map001" files

            # Sets a list of objects that will be affected by an action (per data file)
            # This option only works for data files that supports this behavior (Actors, Items, States...)
            # The ids that you can provide match the IDs in the database.
            # If not provided it will consider all objects
            rgss-db . -f Items.rvdata2 -i 10 122 # This will consider the items with ID: 10 and 122

            # You can also set the list for each data file (if there is more than one)
            # The object IDs list parameter can be repeated for each data file specified
            rgss-db . -f Actors.rvdata2 Items.rvdata2 -i 10 -i 200 300 # 10 for Actors, 200 and 300 for Items


            You can skip the application's CLI menu completely if you supply a supported action.

            The application will start and perform the action, using the given files and object IDs (if any) and close itself when the action finishes

            These are the possible actions:
            - ``export``: Exports RPG Maker database
            - ``export_custom``: Exports specific objects from the RPG Maker database
            - ``import``: Imports external data into the RPG Maker database
            - ``import_custom``: Imports custom external data into the RPG Maker database (merge)

            Here's a few examples with the action option using the default application directory:
            # Opens the current directory and export all data
            rgss-db . -a export

            # Opens the current directory and import all data
            rgss-db . -a import

            # Opens the current directory and export only the Items file
            rgss-db . -a export -f Items.rvdata2

            # Opens the current directory and export only the object with ID: 100 from the Items file
            rgss-db . -a export_custom -f Items.rvdata2 -i 100

            # Opens the current directory and export only the object with ID: 100 from the Items file to a JSON file
            rgss-db . -a export_custom -f Items.rvdata2 -i 100 -t json

        OPTIONS
      BANNER

      # App option back up mode info
      CLI_OPTION_BACK_UP = "Sets the back up mode"

      # App option debug mode info
      CLI_OPTION_DEBUG_MODE = "Sets the debug mode"

      # App option working directory info
      CLI_OPTION_WORKING_DIR = "Sets the working directory"

      # App option action info
      CLI_OPTION_ACTION = "Sets the action to perform"

      # App option file format type info
      CLI_OPTION_FORMAT_TYPE = "Specifies the file format type to use"

      # App option file entries info
      CLI_OPTION_FILE_ENTRIES = "Sets a list of files affected by the action"

      # App option object IDs info
      CLI_OPTION_IDS = "Sets a list of object IDs that will be affected per file"
    end

    #
    # Application information strings
    #
    module StrAppInfo
      # Invalid RPG Maker version label
      VERSION_INVALID_LABEL = "Unknown"

      # Text as a warning when a RPG Maker version is not detected
      VERSION_INVALID_TEXT = <<~EOF
        It was not possible to detect a valid RPG Maker version in the given directory!

        The detected version of RPG Maker determines which type of database is imported

        If the version is unknown, it means that the RPG Maker version could not be resolved, either because
        there are no database files in the given path or because there are files from two versions of the engine
        (such as Items.rvdata2 and Items.rxdata), therefore the correct RPG Maker version cannot be determined

        This is because the app cannot work with different versions of RPG Maker data files at the same time

        Some database classes have the same name but different definitions, which could result in data corruption

        You should exit and fix the problems before interacting further with the database
      EOF

      # Application information data folder text
      #
      # String contains a "%s" flag to insert the data folder
      DATA_FOLDER = "RPG Maker Data Folder: %s"

      # Application information RPG Maker version text
      #
      # String contains a "%s" flag to insert the version
      RPG_VERSION = "RPG Maker Version: %s"
    end

    #
    # Strings used in user prompts
    #
    module StrPrompts
      # Text shown when a prompt operation finishes successfully
      SUCCESS_TEXT = "Operation finished!"

      # Text shown when a prompt is stopped or cancelled
      CANCEL_TEXT = "Cancelling operation..."

      # Text shown on the spinner prompt when the task is completed
      SPINNER_TASK_COMPLETED_TEXT = "Done!"

      # Text shown on the pause prompt when requesting the user to press any key
      PAUSE_ANY_KEYS = "Press any key to continue..."

      # Text shown on the pause prompt when requesting the user to press any key with a timeout
      PAUSE_ANY_KEYS_TIMEOUT = "Press any key to continue... (resumes automatically in :countdown seconds)"

      # Text shown on the pause prompt when requesting the user to press specific keys
      #
      # String contains a "%s" flag to insert the list of keys
      PAUSE_KEYS = "Press %s to continue..."

      # Text shown on the pause prompt when requesting the user to press specific keys with a timeout
      #
      # String contains a "%s" flag to insert the list of keys
      PAUSE_KEYS_TIMEOUT = "Press %s to continue... (resumes automatically in :countdown seconds)"

      # Text shown on the confirmation prompt
      CONFIRM_INPUT_TEXT = "Are you sure you want to continue?"

      # Text shown on the select and multi select prompts
      SELECT_INPUT_TEXT = "What would you like to do?"

      # Text that could be used as a tip message for ask prompts
      ASK_TIP_TEXT = <<~EOF
        Press ENTER to submit the current input

        The option may have a default value between parentheses that will be used
        if the input is left empty.
      EOF

      # Text that could be used as a fail message when an ask prompt fails validation
      ASK_VALIDATION_FAIL_TEXT = "The input is invalid!"

      # Text that could be used as a tip message for select prompts
      SELECT_TIP_TEXT = <<~EOF
        Press ↑/↓ arrows to move the cursor
        Use SPACE or ENTER to select the current item
      EOF

      # Text that could be used as a tip message for multi select prompts
      MULTI_SELECT_TIP_TEXT = <<~EOF
        Press ↑/↓ arrows to move the cursor
        Use SPACE to select the current item
        Press CTRL + A and to select all items available
        You can also use CTRL + R to revert the current selection
        Press ENTER to finish selection
      EOF
    end

    #
    # Menu strings
    #
    # This module contains menu options shown on the screen
    #
    module StrMenu
      # App menu option that represents the main menu
      APP_MENU_MAIN_MENU = "Main Menu"

      # App menu option to go to the actions menu
      APP_MENU_ACTIONS = "Perform Actions"

      # App menu option for export command
      APP_MENU_ACTIONS_EXPORT = "Export RPG Maker Data Files"

      # App menu option for export custom command
      APP_MENU_ACTIONS_EXPORT_CUSTOM = "Export RPG Maker Data Files (Custom)"

      # App menu option for import command
      APP_MENU_ACTIONS_IMPORT = "Import External Data Into RPG Maker"

      # App menu option for import custom command
      APP_MENU_ACTIONS_IMPORT_CUSTOM = "Import External Data Into RPG Maker (Custom)"

      # App menu option to go to app options menu
      APP_MENU_OPTIONS = "Check and Modify Options"

      # App menu option to set the output file format type
      APP_MENU_OPTIONS_SET_FORMAT_TYPE = "Set Type of File Format"

      # App menu option to set the working directory
      APP_MENU_OPTIONS_SET_WORKING_DIR = "Set Working Directory"

      # App menu option to select a list of file entries
      APP_MENU_OPTIONS_SET_ENTRIES = "Set File Entries List"

      # App menu option to select a list of object IDs
      APP_MENU_OPTIONS_SET_IDS = "Set Object IDs List"

      # App menu option to show the values of the current options (pretty format)
      APP_MENU_OPTIONS_SHOW_OPTIONS_PRETTY = "Show Options (Pretty)"

      # App menu option to show the values of the current options (raw format)
      APP_MENU_OPTIONS_SHOW_OPTIONS_RAW = "Show Options (Raw)"

      # App menu option for exiting command
      APP_MENU_EXIT = "Exit"
    end

    #
    # Menu contents strings
    #
    # This module contains the contents for each menu
    #
    module StrMenuContents
      # Main menu information contents
      APP_MENU_MAIN_MENU_TEXT_INFO = <<~EOF
        This is the main menu of RGSS Database

        You can use the first option to perform any action on the current RPG Maker database

        You are also able to see and tweak the application's settings
      EOF

      # Actions menu information contents
      APP_MENU_ACTIONS_TEXT_INFO = <<~EOF
        In this menu you can perform export and import operations on the current RPG Maker database

        You can do the following operations:
          - Export: Exports all RPG Maker database data into external files
          - Export (Custom): Exports specific objects from the RPG Maker database
          - Import: Imports all external data into the RPG Maker database
          - Import (Custom): Imports specific objects ino the RPG Maker database
      EOF

      # Options menu information contents
      APP_MENU_OPTIONS_TEXT_INFO = <<~EOF
        In this menu you can change any supported option's value

        You are also able to show the current value of each option in a table
      EOF
    end

    #
    # Submenu strings
    #
    # This module contains strings used in submenus
    #
    module StrSubMenu
      # Text shown on the exit submenu
      EXIT_TEXT = "Exiting..."

      # Text shown on the export submenu as an information message
      EXPORT_TEXT = <<~EOF
        Choose the data files you want to export from the list of files below

        All data files selected will be exported to the choosen file format

        If you want to cancel this action do not select any data file
      EOF

      # Text shown on the export submenu when loading data files
      EXPORT_LOAD_FILES_TEXT = "Loading RPG Maker database files..."

      # Text shown as an error when the application failed to detect RPG Maker database files
      EXPORT_LOAD_ERROR_TEXT = "No valid RPG Maker database files detected inside the data folder!"

      # Text shown when the user does not select any data files from the export files list
      EXPORT_NO_FILES_ERROR_TEXT = "No data files were selected from the list!"

      # Text shown on the export custom submenu as an information message
      EXPORT_CUSTOM_TEXT = <<~EOF
        Choose the data files you want to export from the list of files below

        You can only select data files that allows object selection.
        If you wish to export a data file that does not appear here
        try the other export action.

        Keep in mind that if you do not select any object from the list or skip the
        selection process all objects will be considered for the export operation

        If you want to cancel this action do not select any data file
      EOF

      # Text shown when asking the user whether they want to select specific objects from a data file or not
      #
      # String contains a "%s" flag to insert the data file name
      EXPORT_CUSTOM_SELECT_OBJ_ID_TEXT = "Do you wish to select specific objects from '%s'?"

      # Text shown when the application is exporting a data file
      #
      # String contains a "%s" flag to insert the data file name
      EXPORT_ACTION_TEXT = "Exporting data file '%s'..."

      # Text shown when the application is exporting a custom data file
      #
      # String contains a "%s" flag to insert the data file name
      EXPORT_CUSTOM_ACTION_TEXT = "Exporting custom data file '%s'..."

      # Text shown on the import submenu as an information message
      IMPORT_TEXT = <<~EOF
        Choose the data files you want to import from the list of files below
        When importing data, all objects are auto. considered for the operation

        A backup of the original database file will be created for each data file
        You can disable this behavior by disabling backups when running the application

        If you want to cancel this action do not select any data file
      EOF

      # Text shown on the import submenu when loading data files
      IMPORT_LOAD_FILES_TEXT = "Loading extracted data files..."

      # Text shown as an error when the application failed to detect external data files
      IMPORT_LOAD_ERROR_TEXT = "No valid extracted data file detected on the application's folder!"

      # Text shown when the user does not select any data files from the import files list
      IMPORT_NO_FILES_ERROR_TEXT = "No data files were selected from the list!"

      # Text shown on the import custom submenu as an information message
      IMPORT_CUSTOM_TEXT = <<~EOF
        Choose which custom data files you want to import from the list of files below

        The data files selected will be merged into their appropiate RPG Maker database file

        New objects will be appended at the end of the list of objects to avoid problems

        You should make sure that any reference to other database files that the new object
        imported has, exists within the RPG Maker database.

        A backup of the original database file will be created for each data file
        You can disable this behavior by disabling backups when running the application

        If you want to cancel this action do not select any data file
      EOF

      # Text shown on the import custom submenu when loading data files
      IMPORT_CUSTOM_LOAD_FILES_TEXT = "Loading custom extracted data files..."

      # Text shown when the application is importing a data file
      #
      # String contains a "%s" flag to insert the data file name
      IMPORT_ACTION_TEXT = "Importing data file '%s'..."

      # Text shown when the application is importing a custom data file
      #
      # String contains a "%s" flag to insert the data file name
      IMPORT_CUSTOM_ACTION_TEXT = "Importing custom data file '%s'..."

      # Text shown on the set format type submenu as an information message
      SET_FORMAT_TYPE_TEXT = <<~EOF
        You can set the type of file format the application will use below

        The choosen file format will be used when exporting data files

        If using binary, RPG Maker files will automatically use the appropiate binary file type
      EOF

      # Text shown on the set format type submenu when updating the file format type
      #
      # String contains a "%s" flag to insert the type of file format
      SET_FORMAT_TYPE_UPDATE_TEXT = "Type of file format updated to: '%s'"

      # Text shown on the set app working directory submenu as an information message
      SET_WORKING_DIR_TEXT = <<~EOF
        You can set the application's working directory to the desired one below

        The path can be either an absolute or relative path to the RPG Maker data folder

        Keep in mind that the app will overwrite any files inside of the working directory!
      EOF

      # Text shown when asking the user to set the app working directory
      SET_WORKING_DIR_ASK_TEXT = "Type the working directory"

      # Text shown when the working directory validation fails
      SET_WORKING_DIR_ASK_FAIL_TEXT = "The path contains invalid characters!"

      # Text shown on the set working directory submenu when updating the working directory
      #
      # String contains a "%s" flag to insert the new working directory
      #
      # String contains a "%s" flag to insert the application working directory
      SET_WORKING_DIR_UPDATE_TEXT = "Application working directory updated to: '%s'"

      # Tip text shown on the set file entries submenu as an information message
      SET_ENTRIES_TEXT = <<~EOF
        You can set a list of file entries that will be pre-selected when performing an action

        Keep in mind that if a file entry is deleted it will be removed from the object ID list too!

        You must type all entries separated by commas!
      EOF

      # Text shown when asking the user to set the list of file entries
      SET_ENTRIES_ASK_TEXT = "Type the list of file entries"

      # Text shown when asking the user to set the list of file entries
      #
      # String contains a "%s" flag to insert the file entries
      SET_ENTRIES_UPDATE_TEXT = "File entries updated to: '%s'"

      # Tip text shown on the set object IDs submenu as an information message
      SET_IDS_TEXT = <<~EOF
        You can set a list of IDs that will be selected for each file entry

        You must type all ID values separated by commas!
      EOF

      # Text shown when the user does not have any file entry to select object IDs from
      SET_IDS_NO_FILES_ERROR_TEXT = "No file entries available to select from!"

      # Text shown when the user does not select any file entries from the files list
      SET_IDS_NO_FILES_SELECTED_ERROR_TEXT = "No file entries were selected from the list!"

      # Text shown when asking the user for the list of object IDs to select for a file entry
      #
      # String contains a "%s" flag to insert the file entry
      SET_IDS_ASK_IDS_TEXT = "Type the list of object IDs for '%s':"

      # Text shown when updating the list of object IDs for a file entry
      #
      # String contains a "%s" flag to insert the hash of file entries and object IDs
      SET_IDS_UPDATE_TEXT = "List of object IDs updated to: '%s'"

      # Text shown on the show options submenu in the raw mode
      SHOW_OPTIONS_RAW_TEXT = <<~EOF
        All options will be shown below, note that not all options are relevant to the user
      EOF

      # Text shown on the show options submenu in the pretty mode
      SHOW_OPTIONS_PRETTY_TEXT = <<~EOF
        All options will be shown below, note that not all options are relevant to the user

        In case the table is unreadable, use the raw mode
      EOF

      # Column 1 text shown on the show options submenu
      SHOW_OPTIONS_COLUMN_1 = "Option ID"

      # Column 2 text shown on the show options submenu
      SHOW_OPTIONS_COLUMN_2 = "Option Value"
    end

    #
    # Other strings module
    #
    module StrOthers
      # Information frame box label
      INFO_FRAME_LABEL = "ℹ️ Information"

      # Warning frame box label
      WARN_FRAME_LABEL = "⚠️ Warning"

      # Error frame box label
      ERRO_FRAME_LABEL = "🅾️ Error"
    end
  end
end
