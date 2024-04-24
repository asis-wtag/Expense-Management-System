class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  validates :body, presence: true, length: { maximum: 100 }
end
