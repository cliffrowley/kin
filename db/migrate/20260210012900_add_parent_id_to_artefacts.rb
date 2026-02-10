class AddParentIdToArtefacts < ActiveRecord::Migration[8.1]
  def change
    add_reference :artefacts, :parent, null: true, foreign_key: { to_table: :artefacts }
  end
end
