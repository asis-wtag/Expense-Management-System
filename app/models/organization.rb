class Organization < ApplicationRecord
  has_many :tradings
  has_one_attached :image
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  before_destroy :delete_attached_image

  private

  def delete_attached_image
    image.purge if image.attached?
  end
end
