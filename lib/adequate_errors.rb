require "adequate_errors/version"
require "adequate_errors/errors"
require "active_model"

module AdequateErrors
  module Patch
    def errors
      @adequate_errors ||= ::AdequateErrors::Errors.new(self, legacy_errors: super)
    end
  end
end

module ActiveModel
  module Model
    prepend AdequateErrors::Patch
  end
end
