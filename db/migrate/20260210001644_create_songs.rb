class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.text :notes
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
