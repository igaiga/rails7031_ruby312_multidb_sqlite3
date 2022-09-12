class CreateWriteLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :write_logs do |t|
      t.string :last_write_string

      t.timestamps
    end
  end
end
