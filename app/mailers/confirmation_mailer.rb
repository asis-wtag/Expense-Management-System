class ConfirmationMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('mailer.confirmation_mailer.subject'))
  end
end
