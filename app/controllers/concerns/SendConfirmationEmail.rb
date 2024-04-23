module SendConfirmationEmail
  def send_email(user_email)
    user = User.find_by(email: user_email)
    if user
      ConfirmationMailer.confirmation_email(user).deliver_now
    else
      Rails.logger.error "User with email #{user_email} not found."
      end
  end
end
