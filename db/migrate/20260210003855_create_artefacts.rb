class CreateArtefacts < ActiveRecord::Migration[8.1]
  def change
    create_table :artefacts do |t|
      t.references :song, null: false, foreign_key: true
      t.integer :artefact_type, null: false
      t.string :title, null: false
      t.text :notes

      t.timestamps
    end
  end
end
