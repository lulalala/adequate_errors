module AdequateErrors
  # Represents one single error
  # @!attribute [r] base
  #   @return [ActiveModel::Base] the object which the error belongs to
  # @!attribute [r] attribute
  #   @return [Symbol] attribute of the object which the error belongs to
  # @!attribute [r] type
  #   @return [Symbol] error's type
  # @!attribute [r] options
  #   @return [Hash] additional options
  # @!attribute [r] inner_error
  #   @return [Error] inner error
  class NestedError < Error
    def initialize(base, inner_error, override_options = {})
      @base = base
      @inner_error = inner_error
      @attribute = override_options.fetch(:attribute) { inner_error.attribute }
      @type = override_options.fetch(:type) { inner_error.type }
      @options = inner_error.options
    end

    attr_reader :inner_error

    # Full message of the error.
    # Sourced from inner error.
    def message
      @inner_error.message
    end
  end
end
