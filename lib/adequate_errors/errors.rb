require 'active_model/errors'
require 'forwardable'
require 'adequate_errors/error'

module AdequateErrors
  class Errors
    extend Forwardable
    def_delegators :@legacy_errors, *Enumerable.instance_methods(false)
    def_delegators :@legacy_errors,
                   :initialize_dup, :copy!, :[], :each, :size, :values, :keys,
                   :empty?, :blank?, :to_xml, :as_json, :to_hash, :added?, :full_messages, :full_messages_for,
                   :full_message, :generate_message, :marshal_dump, :marshal_load, :init_with

    def initialize(base, legacy_errors: nil)
      # Reference to Rails official errors implementation
      @legacy_errors = legacy_errors || ::ActiveModel::Errors.new(base)
      @base = base
      @errors = []
    end

    def clear
      @errors.clear
      @legacy_errors.clear
    end

    def delete(key)
      @errors.delete_if do |error|
        error.attribute == key
      end
      @legacy_errors.delete(key)
    end

    def add(attribute, message = :invalid, options = {})
      @errors.append(::AdequateErrors::Error.new(@base, attribute, message, options))

      @legacy_errors.add(attribute, message, options)
    end

    # TODO: Future plan is to make this class enumerate @errors directly.
    # So when adding new public methods, avoid name collision with Enumerable methods.
    def error_objects
      @errors
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
