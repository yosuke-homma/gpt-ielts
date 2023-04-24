class Exam < ApplicationRecord
  validates :answer, presence: true
  belongs_to :user
end
