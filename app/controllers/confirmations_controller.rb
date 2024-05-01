class ConfirmationsController < ApplicationController
  include SendConfirmationEmail

  before_action :redirect_if_authenticated

  def new
    @user = User.find_by(email: params[:email])
  end

  def create
    send_email(params[:email])
    redirect_to root_path, notice: I18n.t('controller.confirmation.create.verification_mail_sent_message')
  end

  def show
    @user = User.find_by_token_for(:email_confirmation, params[:token])
    if @user && @user.confirm!
      redirect_to root_path, notice: I18n.t('controller.confirmation.show.email_confirmed_message')
    else
      redirect_to root_path, alert: I18n.t('controller.confirmation.show.invalid_token_error')
    end
  end

  private

  def redirect_if_authenticated
    user = User.find_by(email: params[:email])
    return if user.nil?
    redirect_to root_path, alert: I18n.t('controller.confirmation.redirect_if_authenticated.successful_signin_message') if user.confirmed?
  end

  def find_by_confirmation_token(token)
    @user = User.find_by_token_for(:confirm_email, params[:token])
  end
end
