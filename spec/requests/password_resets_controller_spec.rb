require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid email" do
      it "sends a password reset email" do
        expect(PasswordMailer).to receive(:with).and_return(PasswordMailer)
        expect(PasswordMailer).to receive(:password_reset).and_return(double(deliver_now: true))

        post :create, params: { email: user.email }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Check your email to reset your password")
      end
    end

    context "with invalid email" do
      it "does not send an email" do
        expect(PasswordMailer).not_to receive(:password_reset)

        post :create, params: { email: "invalid@example.com" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Check your email to reset your password")
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      token = user.generate_token_for(:password_reset)
      get :edit, params: { token: token }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    context "with valid token and password" do
      it "updates the password" do
        token = user.generate_token_for(:password_reset)
        new_password = "new_password"

        put :update, params: { token: token, user: { password: new_password, password_confirmation: new_password } }
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq("Your password has been reset successfully. Please login.")
      end
    end

    context "with invalid password confirmation" do
      it "renders the edit template with unprocessable_entity status" do
        token = user.generate_token_for(:password_reset)

        put :update, params: { token: token, user: { password: "new_password", password_confirmation: "invalid_confirmation" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
