class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 30 }
  validates :password, length: { minimum: 6 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 20.minutes do
    email
  end

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end
end
