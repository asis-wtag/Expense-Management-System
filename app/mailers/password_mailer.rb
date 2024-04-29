class PasswordMailer < ApplicationMailer
  def password_reset
    mail(to: params[:user].email, subject: I18n.t('mailer.password_mailer.subject'))
  end
end
