require_relative "boot"

require "rails/all"
require_relative "initializers/multi_db" # requireが間に合わないのでここでrequireする

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails7031Ruby312MultidbSqlite3
  class Application < Rails::Application
    config.load_defaults 7.0

    Rails.application.configure do
      config.active_record.database_selector = { delay: 2.seconds }
      config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
      config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::MyContext
    end
  end
end
