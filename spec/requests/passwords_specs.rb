require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:valid_params) do
        {
          user: {
            password: "new_password",
            password_confirmation: "new_password"
          }
        }
      end

      it "updates the user's password" do
        patch :update, params: valid_params
        user.reload
        expect(user.authenticate("new_password")).to eq(user)
      end

      it "redirects to the edit password path with a success notice" do
        patch :update, params: valid_params
        expect(response).to redirect_to(edit_password_path)
        expect(flash[:notice]).to eq("Your password has been updated successfully.")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          user: {
            password: "new_password",
            password_confirmation: "wrong_confirmation"
          }
        }
      end

      it "renders the edit template with unprocessable entity status" do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
      end
    end
  end
end
