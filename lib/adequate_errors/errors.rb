require 'active_model/errors'
require 'forwardable'
require 'adequate_errors/error'

module AdequateErrors
  class Errors
    include Enumerable

    extend Forwardable
    def_delegators :@errors, :each, :size, :clear, *Enumerable.instance_methods(false)

    def initialize(base)
      @base = base
      @errors = []
    end

    def delete(key)
      @errors.delete_if do |error|
        error.attribute == key
      end
    end

    def add(attribute, type = :invalid, options = {})
      @errors.append(::AdequateErrors::Error.new(@base, attribute, type, options))
    end

    def messages
      @errors.map(&:message)
    end

    # @param params [Hash] filter condition
    #   :attribute key matches errors belonging to specific attribute.
    #   :type key matches errors with specific type of error, for example :blank
    #   custom keys can be used to match custom options used during `add`.
    # @return [Array(AdequateErrors::Error)]
    #   If params is empty, all errors are returned.
    def where(params)
      return @errors.dup if params.blank?

      @errors.select {|error|
        error.match?(params)
      }
    end
  end
end
