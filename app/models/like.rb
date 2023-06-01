class Like < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  validates :user_id, uniqueness: { scope: :exam_id }
  validate :cannot_like_own_post

  private

  def cannot_like_own_post
    errors.add(:base, 'You cannot like your own post.') if user_id == exam.user_id
  end
end
