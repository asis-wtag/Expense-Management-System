class SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to root_path
    end
  end

  def create
    entered_email = params[:email].strip
    if user = User.authenticate_by(email: entered_email, password: params[:password])
      if user.confirmed?
        login user
        redirect_to root_path, notice: I18n.t('controller.session.successful_signin_message')
      else
        redirect_to new_confirmation_path(email: user.email), notice: I18n.t('controller.session.required_email_verification_message')
      end
    else
      flash[:alert] = I18n.t('controller.session.invalid_credential_message')
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: I18n.t('controller.session.logged_out_message')
  end
end
