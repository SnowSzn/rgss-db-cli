# frozen_string_literal: true

module RgssDb
  #
  # Jsonable mixin
  #
  module Jsonable
    #
    # Returns this instance as a json-ready hash
    #
    # @return [Hash]
    #
    def as_json
      hash = {}
      hash.store(JSON.create_id, self.class.name)
      instance_variables.each do |ivar|
        ivar_id = ivar.to_s.delete("@")
        ivar_value = instance_variable_get(ivar)
        hash.store(ivar_id, ivar_value)
      end
      hash
    end

    #
    # Converts this instance to a JSON string
    #
    # @param args [Array] Arguments
    #
    # @return [String]
    #
    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
