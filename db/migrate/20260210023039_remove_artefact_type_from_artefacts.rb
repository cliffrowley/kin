class RemoveArtefactTypeFromArtefacts < ActiveRecord::Migration[8.1]
  def change
    remove_column :artefacts, :artefact_type, :integer, null: false
  end
end
