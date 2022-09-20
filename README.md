## 最終書き込み日時の書き込み先を変更するサンプルコード

`config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session`

を次のように変更している。

`config.active_record.database_resolver_context = MyContext`

MyContextクラスはひとまずconfig/application.rbに書いてある。
