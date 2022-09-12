require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# ActiveRecord::Middleware::DatabaseSelector::Resolver::Session からコピーしたものをoriginalにして変更している
# TODO: config/initialize/my_context.rbへ移動したい
class MyContext
  def self.call(request)
    # new(request.session) # original
    new # request.sessionは不要なので渡さない
  end

  # Converts time to a timestamp that represents milliseconds since
  # epoch.
  def self.convert_time_to_timestamp(time) # original
    time.to_i * 1000 + time.usec / 1000
  end

  # Converts milliseconds since epoch timestamp into a time object.
  def self.convert_timestamp_to_time(timestamp) # original
    timestamp ? Time.at(timestamp / 1000, (timestamp % 1000) * 1000) : Time.at(0)
  end

#  def initialize(session) # original
  def initialize
    p "============MyContext#initialize"
    # 今回の仕組みのための設定。レコードが1件でもあれば良く、last_write_stringの値もそれっぽければ何でも良い。
    unless WriteLog.exists?
      p "WriteLog has no records"
      WriteLog.create!(last_write_string: "1662972858553")
    end
  end

  # attr_reader :session # original

  # デバッグ用表示
  def last_write
    p "============ last_write"
    p WriteLog.last.last_write_string.to_i
    WriteLog.last.last_write_string.to_i
  end

  def last_write_timestamp
    p "============last_write_timestamp"
    # self.class.convert_timestamp_to_time(session[:last_write]) # original
    # self.class.convert_timestamp_to_time(WriteLog.last.last_write_string.to_i) # デバッグしなければlast_writeメソッド呼び出し不要
    p self.class.convert_timestamp_to_time(last_write)
    self.class.convert_timestamp_to_time(last_write)
  end

  def update_last_write_timestamp
    p "=== *** === update_last_write_timestamp!!!"
    #session[:last_write] = self.class.convert_time_to_timestamp(Time.now) # original
    # 元のコードがTime.nowだったので、Time.zone.nowではなくTime.nowにしている
    # ここは失敗したときに例外でいいのかな？と迷うが、異常系なので例外投げることにしている
    WriteLog.create!(last_write_string: self.class.convert_time_to_timestamp(Time.now))
  end

  def save(response) # original
  end
end

module Rails7031Ruby312MultidbSqlite3
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    Rails.application.configure do
      # 本番設定
      config.active_record.database_selector = { delay: 10.seconds }
      config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
      config.active_record.database_resolver_context = MyContext
#      config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session # original
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
