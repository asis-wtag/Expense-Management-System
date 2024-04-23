class OrganizationsController < ApplicationController
  def new
    authorize Organization, :new?
  end

  def create
    authorize Organization, :create?
    organization_name = params[:organization_name]
    existing_organization = Organization.where("LOWER(name) = ?", organization_name.downcase).first
    if existing_organization.nil?
      Organization.create(name: organization_name)
      @organization = Organization.find_by(name: organization_name)
      UserOrganization.create(user: current_user, organization: @organization, invitation: 'accepted',role: 'admin')
      redirect_to new_organization_path, notice: "Organization created successfully!"
    else
      redirect_to new_organization_path, notice: "Organization already exists!"
    end
  end

  def show
    @organization = Organization.find(params[:id])
    authorize @organization, :show?
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
      redirect_to invite_people_organization_path, notice: "Invited user to the organization"
    else
      redirect_to invite_people_organization_path, notice: "Given user already exists/invited in the organization!"
    end
  end

  def accept_invitation
    authorize Organization, :accept_invitation?
    @organization = Organization.find(params[:id])
    @user_organization = UserOrganization.find_by(user: current_user,organization: @organization)
    if @user_organization.update(invitation: 'accepted')
      redirect_to organizations_invitations_path, notice: "Successfully accepted invitation"
    else
      redirect_to organizations_invitations_path, notice: "Something went wrong !"
    end
  end

  def reject_invitation
    authorize Organization, :reject_invitation?
    @organization = Organization.find(params[:id])
    @user_organization = UserOrganization.find_by(user: current_user,organization: @organization)
    if @user_organization.update(invitation: 'rejected')
      redirect_to organizations_invitations_path, notice: "Rejected joining invitation"
    else
      redirect_to organizations_invitations_path, notice: "Something went wrong !"
    end
  end

  def my_organizations
    authorize Organization, :my_organizations?
    @my_organizations = UserOrganization.where(user: current_user, invitation: 'accepted')
  end

  def make_admin
    @organization = Organization.find(params[:id])
    authorize @organization, :make_admin?
    @new_admin = User.find(params[:user_id])
    update_record = UserOrganization.find_by(user: @new_admin, organization: @organization)
    if update_record.update(role: 'admin')
      redirect_to organization_path(@organization.id), notice: "Maiden admin successfully"
    else
      redirect_to organization_path(@organization.id), notice: "Something went wrong"
    end
  end

  def tradings
    @organization = Organization.find(params[:id])
    authorize @organization, :tradings?
    current_month = Time.current.beginning_of_month..Time.current.end_of_month
    @tradings = Trading.where(organization: @organization, created_at: current_month).includes(:user).includes(:organization)
    @comments = Comment.where(organization: @organization, created_at: current_month).includes(:organization)
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
    @organization = Organization.find(params[:id])
    authorize @organization, :delete_trading?
    if Trading.destroy(params[:trading_id])
      redirect_to tradings_organization_path, notice: "Deleted trading record successfully !"
    else
      redirect_to tradings_organization_path, notice: "Something went wrong !"
    end
  end

  def add_comment
    @organization = Organization.find(params[:id])
    authorize @organization, :add_comment?
    if Comment.create(user: current_user, organization: @organization, body: params[:comment])
      redirect_to tradings_organization_path, notice: "Comment added successfully !"
    else
    redirect_to tradings_organization_path, notice: "Something went wrong !"
    end
  end

  def delete_comment
    @organization = Organization.find(params[:id])
    authorize @organization, :delete_comment?
    if Comment.destroy(params[:comment_id])
      redirect_to tradings_organization_path, notice: "Comment deleted successfully !"
    else
      redirect_to tradings_organization_path, notice: "Something went wrong !"
    end
  end
end
