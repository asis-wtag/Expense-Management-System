class User < ApplicationRecord
  has_secure_password
  # Validations
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  normalizes :email, with: -> email { email.downcase.strip }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email
  end

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id expires_in: 20.minutes, purpose: :confirm_email
  end

  def unconfirmed?
    !confirmed?
  end
end