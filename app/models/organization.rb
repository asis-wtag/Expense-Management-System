class Organization < ApplicationRecord
  has_many :tradings
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
end
