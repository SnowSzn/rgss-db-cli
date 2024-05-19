# frozen_string_literal: true

module RgssDb
  #
  # Base Error class
  #
  class Error < StandardError
    #
    # Creates a new error object
    #
    # @param message [String] Error message
    #
    def initialize(message)
      super("[rgss-db] #{message}")
    end
  end
end
