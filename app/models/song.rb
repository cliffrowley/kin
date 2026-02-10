class Song < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :artefacts, dependent: :destroy

  validates :title, presence: true

  default_scope { order(updated_at: :desc) }
end
