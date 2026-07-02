require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module EbookLibraryBackend
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true

    config.generators do |generator|
      generator.test_framework :rspec
      generator.fixture_replacement :factory_bot
    end
  end
end
