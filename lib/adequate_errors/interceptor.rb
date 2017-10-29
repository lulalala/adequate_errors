require 'active_model/errors'
require 'forwardable'

# Wrapper around Rails' errors object, to keep AdequateErrors in sync.
module AdequateErrors
  class Interceptor
    extend Forwardable
    def_delegators :@rails_errors, *Enumerable.instance_methods(false)
    def_delegators :@rails_errors,
                   :initialize_dup, :copy!, :[], :each, :size, :values, :keys,
                   :empty?, :blank?, :to_xml, :as_json, :to_hash, :added?, :full_messages, :full_messages_for,
                   :full_message, :generate_message, :marshal_dump, :marshal_load, :init_with

    def initialize(rails_errors, adequate_errors)
      # Reference to Rails official errors implementation
      @rails_errors = rails_errors
      @errors = adequate_errors
    end

    def clear
      @errors.clear
      @rails_errors.clear
    end

    def delete(key)
      @errors.delete(key)
      @rails_errors.delete(key)
    end

    def add(attribute, message = :invalid, options = {})
      @errors.add(attribute, message, options)
      @rails_errors.add(attribute, message, options)
    end
  end
end
