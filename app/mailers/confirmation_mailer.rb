class ConfirmationMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: "Confirm Your Email Address")
  end
end