require "adequate_errors/version"
require "adequate_errors/interceptor"

ActiveSupport.on_load(:i18n) do
  I18n.load_path << File.dirname(__FILE__) + "/adequate_errors/locale/en.yml"
end
