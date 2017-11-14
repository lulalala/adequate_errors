require 'active_model/errors'
require 'forwardable'
require 'adequate_errors/error'

module AdequateErrors
  # Collection of {Error} objects.
  # Provides convenience methods to access these errors.
  # It is accessed via +model.errors.adequate+
  class Errors
    include Enumerable

    extend Forwardable
    def_delegators :@errors, :each, :size, :clear, :blank?, :empty?, *Enumerable.instance_methods(false)

    # @param base [ActiveModel::Base]
    def initialize(base)
      @base = base
      @errors = []
    end

    # Delete errors of attribute
    def delete(attribute)
      @errors.delete_if do |error|
        error.attribute == attribute
      end
    end

    # Adds error.
    # More than one error can be added to the same `attribute`.
    # If no `type` is supplied, `:invalid` is assumed.
    #
    # @param attribute [Symbol] attribute that the error belongs to
    # @param type [Symbol] error's type, defaults to `:invalid`.
    #   As convenience, if type is String/Proc/Lambda,
    #   it will be moved to `options[:message]`,
    #   and type itself will be changed to the default `:invalid`.
    # @param options [Hash] extra conditions such as interpolated value
    def add(attribute, type = :invalid, options = {})

      if !type.is_a? Symbol
        options[:message] = type
        type = :invalid
      end

      @errors.append(::AdequateErrors::Error.new(@base, attribute, type, options))
    end

    # @return [Array(String)] all error messages
    def messages
      @errors.map(&:message)
    end

    # Convenience method to fetch error messages filtered by where condition.
    # @param params [Hash] filter condition, see {#where} for details.
    # @return [Array(String)] error messages
    def messages_for(params)
      where(params).map(&:message)
    end

    # @param params [Hash]
    #   filter condition
    #   The most common keys are +:attribute+ and +:type+,
    #   but other custom keys given during {#add} can also be used.
    #   If params is empty, all errors are returned.
    # @option params [Symbol] :attribute Filtering on attribute the error belongs to
    # @option params [Symbol] :type Filter on type of error
    #
    # @return [Array(AdequateErrors::Error)] matching {Error}.
    def where(params)
      return @errors.dup if params.blank?

      @errors.select {|error|
        error.match?(params)
      }
    end

    # @return [Boolean] whether the given attribute contains error.
    def include?(attribute)
      @errors.any?{|error| error.attribute == attribute }
    end

    # @return [Hash] attributes with their error messages
    def to_hash
      hash = {}
      @errors.each do |error|
        if hash.has_key?(error.attribute)
          hash[error.attribute] << error.message
        else
          hash[error.attribute] = [error.message]
        end
      end
      hash
    end
  end
end
