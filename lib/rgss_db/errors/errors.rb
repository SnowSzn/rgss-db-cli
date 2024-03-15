# frozen_string_literal: true

module RgssDb
  #
  # Base Error class
  #
  class Error < StandardError
    def initialize(message)
      super("[rgss-db] error: #{message}")
    end
  end
end
