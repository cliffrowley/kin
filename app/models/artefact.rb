class Artefact < ApplicationRecord
  belongs_to :song
  belongs_to :parent, class_name: "Artefact", optional: true
  has_many :children, class_name: "Artefact", foreign_key: :parent_id, dependent: :nullify
  has_many :comments, as: :commentable, dependent: :destroy
  has_one :main_mix_song, class_name: "Song", foreign_key: :main_mix_id, dependent: :nullify

  has_one_attached :audio

  enum :artefact_type, { mix: 0, contribution: 1, master: 2 }

  validates :title, presence: true
  validates :artefact_type, presence: true
  validate :parent_belongs_to_same_song

  scope :top_level, -> { where(parent_id: nil) }

  default_scope { order(created_at: :desc) }

  private

  def parent_belongs_to_same_song
    return unless parent
    unless parent.song_id == song_id
      errors.add(:parent, "must belong to the same song")
    end
  end
end
