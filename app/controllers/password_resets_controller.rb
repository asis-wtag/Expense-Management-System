class PasswordResetsController < ApplicationController
  before_action :set_user_by_token, only: [:edit, :update]
  def new

  end

  def create
    if (user = User.find_by(email: params[:email]))
      PasswordMailer.with(
        user: user,
        token: user.generate_token_for(:password_reset)
      ).password_reset.deliver_now
    end
    redirect_to root_path, notice: I18n.t('controller.password_reset.check_email_message')
  end

  def edit

  end

  def update
    if @user.update(password_params)
      redirect_to new_session_path, notice: I18n.t('controller.password_reset.updated_successfully_message')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])
    redirect to new_password_reset_path alert: I18n.t('controller.password_reset.invalid_access_token') unless @user.present?
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
