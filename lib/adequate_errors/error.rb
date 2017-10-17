module AdequateErrors
  class Error
    def initialize(base, attribute, type, options)
      @base = base
      @attribute = attribute
      @type = type
      @options = options
    end

    attr_reader :base,:attribute, :type, :options

    def full_message
      attr_name = @attribute.to_s.tr(".", "_").humanize
      attr_name = @base.class.human_attribute_name(@attribute, default: attr_name)
      I18n.t(:"errors.format",
             attribute: attr_name)
    end

    def match?(params)
      match = true

      if params.key?(:attribute) && @attribute != params[:attribute]
        match = false
      end

      if params.key?(:type) && @type != params[:type]
        match = false
      end

      params.keys.except(:attribute, :type).each do |key|
        if @options[key] != params[key]
          match = false
        end
      end

      match
    end
  end
end
