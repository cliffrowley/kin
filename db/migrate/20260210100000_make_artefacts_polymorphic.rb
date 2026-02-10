class MakeArtefactsPolymorphic < ActiveRecord::Migration[8.0]
  def change
    # Add polymorphic artefactable columns
    add_reference :artefacts, :artefactable, polymorphic: true

    # Migrate existing data: top-level artefacts point to Song, children point to parent Artefact
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE artefacts
          SET artefactable_type = 'Artefact', artefactable_id = parent_id
          WHERE parent_id IS NOT NULL
        SQL
        execute <<-SQL
          UPDATE artefacts
          SET artefactable_type = 'Song', artefactable_id = song_id
          WHERE parent_id IS NULL
        SQL
        # Make polymorphic columns non-nullable now that data is migrated
        change_column_null :artefacts, :artefactable_type, false
        change_column_null :artefacts, :artefactable_id, false
      end
    end

    # Rename main_mix to main_artefact on songs
    rename_column :songs, :main_mix_id, :main_artefact_id

    # Remove old columns
    remove_foreign_key :artefacts, column: :parent_id
    remove_foreign_key :artefacts, :songs
    remove_column :artefacts, :song_id, :integer
    remove_column :artefacts, :parent_id, :integer
  end
end
