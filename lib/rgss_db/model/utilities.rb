# frozen_string_literal: true

module RgssDb
  #
  # Utilities module
  #
  module Utilities
    # Regular expression of invalid characters or sequence of characters
    # @return [Regexp]
    INVALID_CHARACTERS = /[:*?"<>|]|(\bCON\b|\bPRN\b|\bAUX\b|\bNUL\b|\bCOM[1-9]\b|\bLPT[1-9]\b)/i

    #
    # Gets the list of the default (pre-selected) indexes for a TTY selection menu
    #
    # If a block is given, it will be used to evaluate the index selection
    #
    # The block receives the following parameters ``[Object, Integer, Object]``:
    #   - The first one is the current menu option being evaluated
    #   - The second one is the index of the menu option being evaluated
    #   - The third argument iterates through each user option
    #
    # If the block ever returns ``true`` for the current menu option, its index will be saved
    #
    # If no block is given, it will use ``Array#include?`` to check if either the menu option or the menu index exists
    # in the options user list
    #
    # The following flags can be used to alter the behavior:
    #   - all_if_empty: Select all options if the user's options list is empty
    #
    # @param options_menu [Array] Menu options list
    # @param options_user [Array] List of user selected options
    # @param all_if_empty [Boolean] Whether to select all options if the user array is empty
    # @param block [Proc] Evaluation callback
    #
    # @return [Array<Integer>]
    #
    # @yieldparam [Object]
    # @yieldparam [Integer]
    # @yieldparam [Object]
    #
    def self.menu_default_indexes(options_menu, options_user, all_if_empty: false, &block)
      # Checks if user's options list is empty (and populate it with all indexes if allowed)
      return (1..options_menu.size).to_a if options_user.empty? && all_if_empty
      return [] if options_user.empty?

      # Process the menu options list normally
      options_indexes = []
      if block_given?
        options_menu.each_with_index do |menu_option, index|
          menu_index = index + 1
          options_indexes << menu_index if options_user.any? { |opt_user| yield menu_option, menu_index, opt_user }
        end
      else
        options_menu.each_with_index do |menu_option, index|
          menu_index = index + 1
          options_indexes << menu_index if options_user.include?(menu_option) || options_user.include?(menu_index)
        end
      end
      options_indexes
    end

    #
    # Validates the path
    #
    # Returns a ``MatchData`` if the path is invalid, otherwise ``nil``
    #
    # The ``MatchData`` object contains the invalid characters
    #
    # @param path [String] Path
    #
    # @return [MatchData]
    #
    def self.validate_path(path)
      path.to_s.match(INVALID_CHARACTERS)
    end

    #
    # Checks whether the path is valid or not
    #
    # Returns ``true`` if the path is valid, otherwise ``false``
    #
    # @param path [String] Path
    #
    # @return [Boolean]
    #
    def self.valid_path?(path)
      validate_path(path).nil?
    end
  end
end
