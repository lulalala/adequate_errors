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
  class Error
    def initialize(base, attribute, type, options = {})
      @base = base
      @attribute = attribute
      @type = type
      @options = options
    end

    attr_reader :base, :attribute, :type, :options

    # Full message of the error.
    #
    # === Key differences to Rails vanilla errors
    #
    # ==== 1. Flexible positioning of attribute name interpolation
    #
    # In Rails, errors' full messages are always prefixed with attribute name,
    # and if prefix is not wanted, developer often adds error to the `base' attribute instead.
    # This can be unreasonable in different languages or special business requirements.
    #
    # AdequateErrors leaves the attribute placement to the developer.
    # For each error message in the locale file, the %{attribute} indicates placement of the attribute.
    # The same error can have prefix in English, and be prefix-less in Russian.
    # If no prefix is needed, one should update the locale file accordingly,
    #
    # ==== 2. Message evaluated lazily
    #
    # In Rails, error message is evaluated during the `add` call.
    # AdequateErrors evaluates message lazily at `message` call instead,
    # so one can change message locale after model has been validated.
    #
    # === Order of I18n lookup:
    #
    # Error messages are first looked up in <tt>activemodel.adequate_errors.models.MODEL.attributes.ATTRIBUTE.MESSAGE</tt>,
    # if it's not there, it's looked up in <tt>activemodel.adequate_errors.models.MODEL.MESSAGE</tt> and if
    # that is not there also, it returns the translation of the default message
    # (e.g. <tt>activemodel.errors.messages.MESSAGE</tt>). The translated model
    # name, translated attribute name and the value are available for
    # interpolation.
    #
    # When using inheritance in your models, it will check all the inherited
    # models too, but only if the model itself hasn't been found. Say you have
    # <tt>class Admin < User; end</tt> and you wanted the translation for
    # the <tt>:blank</tt> error message for the <tt>title</tt> attribute,
    # it looks for these translations:
    #
    # * <tt>activemodel.adequate_errors.models.admin.attributes.title.blank</tt>
    # * <tt>activemodel.adequate_errors.models.admin.blank</tt>
    # * <tt>activemodel.adequate_errors.models.user.attributes.title.blank</tt>
    # * <tt>activemodel.adequate_errors.models.user.blank</tt>
    # * any default you provided through the +options+ hash (in the <tt>activemodel.adequate_errors</tt> scope)
    # * <tt>activemodel.adequate_errors.messages.blank</tt>
    # * <tt>adequate_errors.attributes.title.blank</tt>
    # * <tt>adequate_errors.messages.blank</tt>
    def message
      if @options[:message].is_a?(Symbol)
        type = @options.delete(:message)
      else
        type = @type
      end

      if @base.class.respond_to?(:i18n_scope)
        defaults = @base.class.lookup_ancestors.map do |klass|
          [ :"#{@base.class.i18n_scope}.adequate_errors.models.#{klass.model_name.i18n_key}.attributes.#{attribute}.#{type}",
            :"#{@base.class.i18n_scope}.adequate_errors.models.#{klass.model_name.i18n_key}.#{type}" ]
        end
      else
        defaults = []
      end

      defaults << :"#{@base.class.i18n_scope}.adequate_errors.messages.#{type}" if @base.class.respond_to?(:i18n_scope)
      defaults << :"adequate_errors.attributes.#{attribute}.#{type}"
      defaults << :"adequate_errors.messages.#{type}"

      defaults.compact!
      defaults.flatten!

      key = defaults.shift
      defaults = @options.delete(:message) if @options[:message]
      value = (attribute != :base ? @base.send(:read_attribute_for_validation, attribute) : nil)

      i18n_options = {
        default: defaults,
        model: @base.model_name.human,
        attribute: humanized_attribute,
        value: value,
        object: @base
      }.merge!(@options)

      I18n.translate(key, i18n_options)
    end

    # @param (see Errors#where)
    # @return [Boolean] whether error matches the params
    def match?(params)
      if params.key?(:attribute) && @attribute != params[:attribute]
        return false
      end

      if params.key?(:type) && @type != params[:type]
        return false
      end

      (params.keys - [:attribute, :type]).each do |key|
        if @options[key] != params[key]
          return false
        end
      end

      true
    end

    private

    def humanized_attribute
      default = @attribute.to_s.tr(".", "_").humanize
      @base.class.human_attribute_name(@attribute, default: default)
    end

  end
end
