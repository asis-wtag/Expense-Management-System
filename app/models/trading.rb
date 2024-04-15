class Trading < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  validates :amount, presence: true
end
