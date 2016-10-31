class Micropost < ApplicationRecord
  belongs_to :user
  has_many :replies
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1400 }
end
