class Artefact < ApplicationRecord
  belongs_to :artefactable, polymorphic: true
  has_many :artefacts, as: :artefactable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :main_artefact_song, class_name: "Song", foreign_key: :main_artefact_id, dependent: :nullify

  has_one_attached :audio

  validates :title, presence: true

  scope :top_level, -> { where(artefactable_type: "Song") }

  default_scope { order(created_at: :desc) }

  # Walk up the artefactable chain to find the owning song
  def song
    current = self
    while current.artefactable.is_a?(Artefact)
      current = current.artefactable
    end
    current.artefactable
  end

  # Convenience aliases for readability
  def parent
    artefactable if artefactable.is_a?(Artefact)
  end

  def children
    artefacts
  end
end
