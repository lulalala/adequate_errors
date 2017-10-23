require "adequate_errors/version"

module AdequateErrors
end

require "adequate_errors/errors"

module ActiveModel
  module Validations
    def errors
      @adequate_errors ||= ::AdequateErrors::Errors.new(self)
    end
  end
end
