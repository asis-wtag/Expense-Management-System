class PasswordsController < ApplicationController
  before_action :authenticate_user!
  def edit

  end

  def update
    if current_user.update(password_params)
      redirect_to edit_password_path, notice: I18n.t('controller.password_reset.updated_successfully_message')
    else
      flash[:notice] = @user.errors.full_messages.join('. ')
      redirect_to root_path
    end
  end

  private

  def password_params
    params.require(:user).permit(
      :password,
      :password_confirmation,
      :password_challenge
    ).with_defaults(password_challenge: "")
  end
end
