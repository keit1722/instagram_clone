require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InstagramClone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.skip_routes true # ルーティングを自動生成しない
      g.assets false # CSS、JavaScriptファイルを自動生成しない
      g.helper false # helperファイルを自動生成しない
      g.test_framework false # testファイルを自動生成しない
    end

    config.time_zone = 'Tokyo' # Railsアプリケーション自体のタイムゾーンを東京時間に指定
    config.active_record.default_timezone = :local # DB読み書きの際に使うタイムゾーンをOSのタイムゾーンに指定

    config.i18n.default_locale = :ja # デフォルトのlocaleを日本語に指定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s] # 複数のlocalファイルを読み込まれるよう設定
  end
end
