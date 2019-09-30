# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Pppp
  # Application config
  class Application < Rails::Application
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales',
                                                 '*.{rb,yml}')]
    config.i18n.default_locale = :de
  end
end
