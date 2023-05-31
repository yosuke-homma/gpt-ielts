class Exam < ApplicationRecord
  validates :answer, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
