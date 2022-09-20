# Multi-db Configuration
#
# This file is used for configuration settings related to multiple databases.
#
# Enable Database Selector
#
# Inserts middleware to perform automatic connection switching.
# The `database_selector` hash is used to pass options to the DatabaseSelector
# middleware. The `delay` is used to determine how long to wait after a write
# to send a subsequent read to the primary.
#
# The `database_resolver` class is used by the middleware to determine which
# database is appropriate to use based on the time delay.
#
# The `database_resolver_context` class is used by the middleware to set
# timestamps for the last write to the primary. The resolver uses the context
# class timestamps to determine how long to wait before reading from the
# replica.
#
# By default Rails will store a last write timestamp in the session. The
# DatabaseSelector middleware is designed as such you can define your own
# strategy for connection switching and pass that into the middleware through
# these configuration options.
#
# Rails.application.configure do
#   config.active_record.database_selector = { delay: 2.seconds }
#   config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
# #  config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
#   config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::MyContext
# end

class ActiveRecord::Middleware::DatabaseSelector::Resolver::MyContext
  def self.call(request)
    new
  end

  def self.convert_time_to_timestamp(time)
    time.to_i * 1000 + time.usec / 1000
  end

  def self.convert_timestamp_to_time(timestamp)
    timestamp ? Time.at(timestamp / 1000, (timestamp % 1000) * 1000) : Time.at(0)
  end

  def initialize
    # 今回の仕組みのための設定。レコードが1件でもあれば良く、last_write_stringの値も現在時刻よりも前ならばなんでも良い。
    unless WriteLog.exists?
      WriteLog.create!(last_write_string: "1600000000000")
    end
  end

  def last_write_timestamp
    self.class.convert_timestamp_to_time(WriteLog.last.last_write_string.to_i)
  end

  def update_last_write_timestamp
    # 元のコードがTime.nowだったので、Time.zone.nowではなくTime.nowにしている
    # ここは失敗したときに例外でいいのかな？と迷うが、異常系なので例外投げることにしている
    WriteLog.create!(last_write_string: self.class.convert_time_to_timestamp(Time.now))
  end

  def save(response)
  end
end

#
# Enable Shard Selector
#
# Inserts middleware to perform automatic shard swapping. The `shard_selector` hash
# can be used to pass options to the `ShardSelector` middleware. The `lock` option is
# used to determine whether shard swapping should be prohibited for the request.
#
# The `shard_resolver` option is used by the middleware to determine which shard
# to switch to. The application must provide a mechanism for finding the shard name
# in a proc. See guides for an example.
#
# Rails.application.configure do
#   config.active_record.shard_selector = { lock: true }
#   config.active_record.shard_resolver = ->(request) { Tenant.find_by!(host: request.host).shard }
# end
