class AddIndexToLogs < ActiveRecord::Migration[5.1]
  def change
    add_index :logs, [:ip_address, :region, :country]
    add_index :logs, :time
  end
end
