class Exam < ApplicationRecord
  validates :answer, presence: true
  belongs_to :user
  scope :recent, -> { order(created_at: :desc, id: :asc) }
end
