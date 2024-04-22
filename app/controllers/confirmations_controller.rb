class ConfirmationsController < ApplicationController
  include SendConfirmationEmail

  before_action :redirect_if_authenticated

  def new
      @user = User.find_by(email: params[:email])
  end

  def create
    user = User.find_by(email: params[:email])
    send_email(user.email)
    redirect_to root_path, notice: "Verification email sent again, Check your email !"
  end

  def show # Show action is doing update actions job because there is a bug when we change the method to update and use path helper. Doing the path helper's job customly is also bringing several complexity
    @user = User.find_by_token_for(:email_confirmation, params[:token])
    if @user && @user.confirm!
      redirect_to root_path, notice: "Your email has been successfully confirmed."
    else
      redirect_to root_path, alert: "Invalid confirmation token."
    end
  end

  private

  def redirect_if_authenticated
    user = User.find_by(email: params[:email])
    return if user.nil?
    redirect_to root_path, alert: "You have signed in successfully !" if user.confirmed?
  end

  def find_by_confirmation_token(token)
    @user = User.find_by_token_for(:confirm_email, params[:token])
  end

end
