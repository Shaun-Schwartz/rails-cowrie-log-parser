class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.column :time, 'timestamp with time zone'
      t.string :protocol
      t.string :status
      t.string :ip_address
      t.text :message
      t.string :username
      t.string :password
      t.string :region
      t.string :country

      t.timestamps
    end
  end
end
