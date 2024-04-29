RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    context "when user is signed in" do
      before { allow(controller).to receive(:user_signed_in?).and_return(true) }

      it "redirects to organizations invitations path" do
        get :new
        expect(response).to redirect_to(organizations_invitations_path)
      end
    end

    context "when user is not signed in" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context "with valid credentials and confirmed user" do
      let(:user) { FactoryBot.create(:user, confirmed_at: Time.current) }
      let(:valid_params) { { email: user.email, password: "password" } }

      it "logs in the user" do
        allow(User).to receive(:authenticate_by).and_return(user)
        post :create, params: valid_params
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to root path with notice" do
        allow(User).to receive(:authenticate_by).and_return(user)
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("You have signed in successfully !")
      end
    end

    context "with valid credentials but unconfirmed user" do
      let(:user) { FactoryBot.create(:user) }
      let(:valid_params) { { email: user.email, password: "password" } }

      it "redirects to new confirmation path with notice" do
        allow(User).to receive(:authenticate_by).and_return(user)
        post :create, params: valid_params
        expect(response).to redirect_to(new_confirmation_path(email: user.email))
        expect(flash[:notice]).to eq("You need to verify your email first !")
      end
    end

    context "with invalid credentials" do
      let(:invalid_params) { { email: "invalid@example.com", password: "password" } }

      it "renders the new template with unprocessable_entity status" do
        allow(User).to receive(:authenticate_by).and_return(nil)
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end

      it "sets flash alert message" do
        allow(User).to receive(:authenticate_by).and_return(nil)
        post :create, params: invalid_params
        expect(flash[:alert]).to eq("Invalid email or password !")
      end
    end
  end

  describe "DELETE #destroy" do
    before { allow(controller).to receive(:user_signed_in?).and_return(true) }

    it "logs out the user" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path with notice" do
      delete :destroy
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been logged out.")
    end
  end
end
