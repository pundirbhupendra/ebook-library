require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.active_storage.service = :local
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.action_controller.default_url_options = {
    host: ENV.fetch("APP_HOST", "localhost"),
    port: ENV.fetch("APP_PORT", 3000)
  }
  config.hosts.clear
end
