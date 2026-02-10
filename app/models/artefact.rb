class Artefact < ApplicationRecord
  belongs_to :song

  has_one_attached :audio

  enum :artefact_type, { mix: 0, contribution: 1, master: 2 }

  validates :title, presence: true
  validates :artefact_type, presence: true

  default_scope { order(created_at: :desc) }
end
