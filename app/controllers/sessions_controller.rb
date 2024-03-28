class SessionsController < ApplicationController
  def new

  end
  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      if user.confirmed?
        login user
        redirect_to root_path, notice: "You have signed in successfully."
      else
        redirect_to new_confirmation_path(email: user.email), notice: "You need to verify your email first !"
      end
    else 
      flash[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    logout current_user
    redirect_to root_path, notice: "You have been logged out."
  end
end