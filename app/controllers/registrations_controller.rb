class RegistrationsController < ApplicationController
  include SendConfirmationEmail

  def new
    if user_signed_in?
      redirect_to root_path
    end
    @user_1 = User.new
  end

  def create
    if params[:user][:name].strip.empty?
      flash[:alert] = I18n.t('controller.registration.create.empty_name_error_message')
      redirect_back fallback_location: root_path
      return
    end
    if params[:user][:email].strip.empty?
      flash[:alert] = I18n.t('controller.registration.create.empty_email_error_message')
      redirect_back fallback_location: root_path
      return
    end
    @user = User.find_by(email: params[:user][:email])
    if @user.present?
      @user = nil
      flash[:alert] = I18n.t('controller.registration.create.duplicate_email_message')
      redirect_back fallback_location: root_path
    else
      @user = User.new(registration_params)
      if @user.save
        send_email(@user.email)
        redirect_to root_path, notice: I18n.t('controller.registration.create.successfully_sent_verification_mail_message')
      else
        flash[:alert] = @user.errors.full_messages.first
        redirect_back fallback_location: root_path
      end
    end
  end

  private

  def registration_params
    permitted_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    permitted_params[:name]&.strip!
    permitted_params[:email]&.strip!
    permitted_params
  end
end
