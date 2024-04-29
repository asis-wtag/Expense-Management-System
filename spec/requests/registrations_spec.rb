RSpec.describe RegistrationsController, type: :controller do

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { { user: { name: "John Doe", email: "john@example.com", password: "password", password_confirmation: "password" } } }

      it "creates a new user" do
        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(1)
      end

      it "sends a verification email" do
        expect_any_instance_of(RegistrationsController).to receive(:send_email).with("john@example.com")

        post :create, params: valid_params
      end

      it "redirects to root path with notice" do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Verification email sent, Check your email !")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { user: { name: "", email: "invalid_email", password: "password", password_confirmation: "password" } } }

      it "does not create a new user" do
        expect do
          post :create, params: invalid_params
        end.not_to change(User, :count)
      end

      it "renders the new template with unprocessable_entity status" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end

    context "when email already exists" do
      let!(:existing_user) { FactoryBot.create(:user, email: "existing@example.com") }
      let(:existing_params) { { user: { name: "John Doe", email: "existing@example.com", password: "password", password_confirmation: "password" } } }

      it "does not create a new user" do
        expect do
          post :create, params: existing_params
        end.not_to change(User, :count)
      end

    end
  end
end
