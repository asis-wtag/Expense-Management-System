class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    redirect_to root_path, alert: I18n.t('controller.application.login_required_error') unless user_signed_in?
  end

  def current_user
    @user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def authenticate_user_from_session
    @user = User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  helper_method :user_signed_in?
  def login(user)
    @user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout
    @user = nil
    reset_session
  end

  def user_not_authorized
    if !user_signed_in?
      redirect_to root_path, alert: I18n.t('controller.application.user_not_logged_in_error')
    else
      redirect_to root_path, alert: I18n.t('controller.application.unauthorized_action_error')
    end
  end
end
