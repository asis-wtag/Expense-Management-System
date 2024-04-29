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
      redirect_to new_organization_path, notice: I18n.t('controller.organization.create.successful_creation_message')
    else
      redirect_to new_organization_path, notice: I18n.t('controller.organization.create.already_exists_error')
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
      UserOrganization.create(user: @new_org_user, organization: @organization, invitation: I18n.t('controller.organization.invitation_status.pending'), role: I18n.t('controller.organization.users_role.non-admin'))
      redirect_to invite_people_organization_path, notice: I18n.t('controller.organization.add_people.invitation_successful_message')
    else
      redirect_to invite_people_organization_path, notice: I18n.t('controller.organization.add_people.user_already_in_organization_message')
    end
  end

  def remove_people
    @organization = Organization.find(params[:id])
    authorize @organization, :remove_people?
    @remove_org_user = User.find(params[:user_id])
    if UserOrganization.destroy_by(user: @remove_org_user)
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.remove_people.successfully_removed_message')
    else
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def accept_invitation
    authorize Organization, :accept_invitation?
    @organization = Organization.find(params[:id])
    @user_organization = UserOrganization.find_by(user: current_user, organization: @organization)
    if @user_organization.update(invitation: 'accepted')
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.accept_invitation.accepted_message')
    else
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def reject_invitation
    authorize Organization, :reject_invitation?
    @organization = Organization.find(params[:id])
    @user_organization = UserOrganization.find_by(user: current_user,organization: @organization)
    if @user_organization.update(invitation: 'rejected')
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.reject_invitation.rejected_message')
    else
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.something_went_wrong_message')
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
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.make_admin.successful_message')
    else
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.something_went_wrong_message')
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
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.create_trading.successful_message')
    else
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def search_trading
    @organization = Organization.find(params[:id])
    authorize @organization, :search_trading?
  end

  def filtered_tradings
    @organization = Organization.find(params[:id])
    authorize @organization, :filtered_tradings?
    start_date = params[:start_date]
    end_date = Date.parse(params[:end_date]).next_day.to_s
    @filtered_tradings = Trading.where(created_at: start_date..end_date)
    @filtered_comments = Comment.where(created_at: start_date..end_date)
  end

  def delete_trading
    @organization = Organization.find(params[:id])
    authorize @organization, :delete_trading?
    if Trading.destroy(params[:trading_id])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.delete_trading.successful_message')
    else
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def add_comment
    @organization = Organization.find(params[:id])
    authorize @organization, :add_comment?
    if Comment.create(user: current_user, organization: @organization, body: params[:comment])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.add_comment.successful_message')
    else
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def delete_comment
    @organization = Organization.find(params[:id])
    authorize @organization, :delete_comment?
    if Comment.destroy(params[:comment_id])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.delete_comment.successful_message')
    else
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def delete_organization
    @organization = Organization.find(params[:id])
    authorize @organization, :delete_organization?
    if Trading.where(organization: @organization).destroy_all && UserOrganization.where(organization: @organization).destroy_all && Comment.where(organization: @organization).destroy_all && Organization.destroy(params[:id])
      redirect_to organizations_my_organizations_path, notice: I18n.t('controller.organization.delete_organization.successful_message')
    else
      redirect_to organizations_my_organizations_path, notice: I18n.t('controller.organization.something_went_wrong_message')
    end
  end
end
