class Song < ApplicationRecord
  belongs_to :creator, class_name: "User"

  validates :title, presence: true

  default_scope { order(updated_at: :desc) }
end
