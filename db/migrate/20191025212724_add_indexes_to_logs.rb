class AddIndexesToLogs < ActiveRecord::Migration[5.1]
  def change
    add_index :logs, :ip_address
    add_index :logs, :session_id
  end
end
