class OrganizationsController < ApplicationController
  def new
    authorize Organization, :new?
  end
  def create
    authorize Organization, :create?
    organization_name = params[:organization_name]
    existing_organization = Organization.where("LOWER(name) = ?", organization_name.downcase).first

    if existing_organization.nil?
      @organization = Organization.create(name: organization_name)
      UserOrganization.create(user: current_user, organization: @organization, invitation: 'accepted',role: 'admin')
      redirect_to new_organization_path, notice: "Organization created successfully!"
    else
      redirect_to new_organization_path, notice: "Organization already exists!"
    end
  end

  def show
    authorize Organization, :show?
    @organization = Organization.find(params[:id])
    @user_organizations = UserOrganization.where(organization: @organization)
  end

  def invitations
    authorize Organization, :invitations?
    @user_organizations = UserOrganization.where(user: current_user, invitation: 'pending')
  end
  def invite_people
    @organization = Organization.find(params[:id])
    authorize @organization, :invite_people?
  end

  def add_people
    @organization = Organization.find(params[:id])
    authorize @organization, :add_people?
    @new_org_user = User.find_by(email: params[:organization][:email])
    if UserOrganization.find_by(user: @new_org_user, organization: @organization).nil?
      UserOrganization.create(user: @new_org_user, organization: @organization, invitation: 'pending', role: 'non-admin')
      redirect_to invite_people_organization_path, notice: "Added user successfully to the organization"
    else
      redirect_to invite_people_organization_path, notice: "Given user already exists/invited in the organization!"
    end

  end

  def make_admin
    authorize Organization, :make_admin?
  end

  def add_trading
    @organization = Organization.find(params[:id])
    authorize @organization, :add_trading?
  end

  def create_trading
    @organization = Organization.find(params[:id])
    authorize @organization, :create_trading?
    if Trading.create(user: current_user, organization: @organization, amount: params[:amount] )
      redirect_to add_trading_organization_path, notice: "Transaction record added successfully !"
    else
      redirect_to add_trading_organization_path, notice: "Failed to add transaction, something went wrong !"
    end
  end

  def delete_trading
    authorize Organization, :delete_trading?
  end

  def create_comment
    authorize Organization, :create_comment?
  end

end
