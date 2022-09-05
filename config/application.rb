require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# ひとまずActiveRecord::Middleware::DatabaseSelector::Resolver::Session からコピー
class MyContext
  def self.call(request)
#    p "============call"
    new(request.session)
  end

  # Converts time to a timestamp that represents milliseconds since
  # epoch.
  def self.convert_time_to_timestamp(time)
    time.to_i * 1000 + time.usec / 1000
  end

  # Converts milliseconds since epoch timestamp into a time object.
  def self.convert_timestamp_to_time(timestamp)
    timestamp ? Time.at(timestamp / 1000, (timestamp % 1000) * 1000) : Time.at(0)
  end

  def initialize(session)
#    p "============initialize"
    @session = session
  end

  #attr_reader :session
  def session
    p "============session"
    @session
  end

  def last_write_timestamp
    p "============last_write_timestamp"
    self.class.convert_timestamp_to_time(session[:last_write])
  end

  def update_last_write_timestamp
    p "============update_last_write_timestamp"
    session[:last_write] = self.class.convert_time_to_timestamp(Time.now)
  end

  def save(response)
  end
end

module Rails7031Ruby312MultidbSqlite3
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    Rails.application.configure do
      config.active_record.database_selector = { delay: 2.seconds }
      config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
      #config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
      config.active_record.database_resolver_context = MyContext
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
