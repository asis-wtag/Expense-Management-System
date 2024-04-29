module SendConfirmationEmail
  def send_email(user_email)
    user = User.find_by(email: user_email)
    if user.present?
      ConfirmationMailer.confirmation_email(user).deliver_now
    else
      Rails.logger.error I18n.t('controller.concern.email_not_found')
    end
  end
end
