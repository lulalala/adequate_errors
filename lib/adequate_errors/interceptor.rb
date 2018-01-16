require "active_model/errors"
require "adequate_errors/errors"

module AdequateErrors
  # Wraps around Rails' errors object, intercepting its state changes
  # in order to update AdequateErrors' errors object.
  module Interceptor
    def initialize(base)
      rails_errors = super
      @adequate_errors = ::AdequateErrors::Errors.new(base)
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
      adequate_options = options.dup

      messages = super

      if options.has_key?(:message) && !options[:message].is_a?(Symbol)
        adequate_options[:message] = full_message(attribute, messages.last)
      end

      adequate_message = if !message.is_a?(Symbol)
        full_message(attribute, messages.last)
      else
        message
      end

      @adequate_errors.add(attribute, adequate_message, adequate_options)

      messages
    end

    # Accessor
    def adequate
      @adequate_errors
    end
  end
end

# @private
module ActiveModel
  class Errors
    prepend AdequateErrors::Interceptor
  end
end
