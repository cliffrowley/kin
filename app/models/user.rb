class User < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)
    return nil unless user

    user.update!(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name
    )
    user
  end
end
