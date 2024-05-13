# frozen_string_literal: true

module RgssDb
  #
  # Jsonable constructor module
  #
  module JsonableConstructor
    #
    # JSON constructor
    #
    # This constructor is used to create a default instance
    #
    # Note: Needs to be overriden in case class constructor needs arguments
    #
    # @param args [Array]
    #
    # @return Class instance
    #
    def json_new(*args)
      new(*args)
    end

    #
    # JSON deserializer
    #
    # @param hash [Hash]
    # @param args [Array]
    #
    # @return Class instance
    #
    def json_create(hash, *args)
      instance = json_new(*args)
      hash.each_pair do |key, value|
        ivar = "@#{key}".to_sym
        instance.instance_variable_set(ivar, value) if instance.instance_variables.include?(ivar)
      end
      instance
    end
  end
end
