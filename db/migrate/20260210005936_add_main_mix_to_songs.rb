class AddMainMixToSongs < ActiveRecord::Migration[8.1]
  def change
    add_reference :songs, :main_mix, null: true, foreign_key: { to_table: :artefacts }
  end
end
