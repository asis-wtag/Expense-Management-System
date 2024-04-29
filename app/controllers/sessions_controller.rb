class SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to organizations_invitations_path
    end
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      if user.confirmed?
        login user
        redirect_to root_path, notice: I18n.t('controller.session.successful_signin_message')
      else
        redirect_to new_confirmation_path(email: user.email), notice: I18n.t('controller.session.required_email_verification_message')
      end
    else
      flash[:alert] = I18n.t('controller.session.invalid_credential_message')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "You have been logged out."
  end
end
