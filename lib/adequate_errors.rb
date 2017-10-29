require "adequate_errors/version"
require "adequate_errors/errors"
require "active_model"

module AdequateErrors
  module Patch
    def errors
      return @adequate_errors_interceptor if defined?(@adequate_errors_interceptor)

      rails_errors = super
      @adequate_errors = ::AdequateErrors::Errors.new(self, rails_errors)
      @adequate_errors_interceptor = ::AdequateErrors::Interceptor.new(self, rails_errors, @adequate_errors)
    end

    def adequate_errors
      return @adequate_errors if defined?(@adequate_errors_interceptor)
      errors
      @adequate_errors
    end
  end
end

module ActiveModel
  module Model
    prepend AdequateErrors::Patch
  end
end
