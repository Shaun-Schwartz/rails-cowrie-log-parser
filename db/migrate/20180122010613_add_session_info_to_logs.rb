class AddSessionInfoToLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :session_id, :string
    add_column :logs, :session_length, :float
  end
end
