require "active_model/errors"
require "adequate_errors/errors"

# Wraps Rails' errors object,
# monitor updates to sync AdequateErrors.
module AdequateErrors
  module Interceptor
    def initialize(base)
      rails_errors = super
      @adequate_errors = ::AdequateErrors::Errors.new(self, rails_errors)
      rails_errors
    end

    def clear
      super
      @adequate_errors.clear
    end

    def delete(key)
      super
      @adequate_errors.delete(key)
    end

    def add(attribute, message = :invalid, options = {})
      super
      @adequate_errors.add(attribute, message, options)
    end

    # Accessor
    def adequate
      @adequate_errors
    end
  end
end

module ActiveModel
  class Errors
    prepend AdequateErrors::Interceptor
  end
end
