class Song < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :artefacts, as: :artefactable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :main_artefact, class_name: "Artefact", optional: true

  validates :title, presence: true
  validates :tempo, numericality: { greater_than: 0 }, allow_nil: true
  validate :main_artefact_belongs_to_song

  default_scope { order(updated_at: :desc) }

  # All artefacts belonging to this song (including nested children)
  def all_artefacts
    Artefact.where(artefactable: self).or(
      Artefact.where(artefactable: Artefact.where(artefactable: self))
    )
  end

  private

  def main_artefact_belongs_to_song
    return unless main_artefact
    unless main_artefact.song == self
      errors.add(:main_artefact, "must belong to this song")
    end
  end
end
