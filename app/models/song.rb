class Song < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :artefacts, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :main_mix, class_name: "Artefact", optional: true

  validates :title, presence: true
  validates :tempo, numericality: { greater_than: 0 }, allow_nil: true
  validate :main_mix_belongs_to_song

  default_scope { order(updated_at: :desc) }

  private

  def main_mix_belongs_to_song
    return unless main_mix
    unless main_mix.song_id == id
      errors.add(:main_mix, "must belong to this song")
    end
  end
end
