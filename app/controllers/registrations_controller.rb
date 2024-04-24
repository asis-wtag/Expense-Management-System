class RegistrationsController < ApplicationController
  include SendConfirmationEmail

  def new
    @user_1 = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      redirect_to root_path, notice: "Email already exists "
    else
      @user = User.new(registration_params)
      if @user.save
        send_email(@user.email)
        redirect_to root_path, notice: "Verification email sent, Check your email !"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name,:email, :password, :password_confirmation)
  end
end
