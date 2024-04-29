class RegistrationsController < ApplicationController
  include SendConfirmationEmail

  def new
    @user_1 = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      redirect_to root_path, I18n.t('controller.registration.create.duplicate_email_message')
    else
      @user = User.new(registration_params)
      if @user.save
        send_email(@user.email)
        redirect_to root_path, notice: I18n.t('controller.registration.create.successfully_sent_verification_mail_message')
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
