require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:organization) { FactoryBot.create(:organization) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authorize).and_return(true)
  end

  describe "GET #new" do
    it "authorizes new organization creation" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid organization name" do
      it "creates a new organization" do
        post :create, params: { organization_name: "New Organization" }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_organization_path)
        expect(flash[:notice]).to eq("Organization created successfully !")
      end
    end

    context "with existing organization name" do
      it "redirects with a notice" do
        existing_organization = FactoryBot.create(:organization)
        post :create, params: { organization_name: existing_organization.name }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_organization_path)
        expect(flash[:notice]).to eq("Organization already exists, try a different name !")
      end
    end
  end

  describe "GET #show" do
    it "authorizes organization show" do
      get :show, params: { id: organization.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #invitations" do
    it "authorizes organization invitations" do
      get :invitations
      expect(response).to have_http_status(:success)
    end
  end
end
