class AddMetadataToSongs < ActiveRecord::Migration[8.1]
  def change
    add_column :songs, :key, :string
    add_column :songs, :tempo, :decimal
    add_column :songs, :lyrics, :text
  end
end
