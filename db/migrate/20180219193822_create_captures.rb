class CreateCaptures < ActiveRecord::Migration[5.1]
  def change
    create_table :captures do |t|
      t.string :name
      t.references :log, foreign_key: true

      t.timestamps
    end
  end
end
