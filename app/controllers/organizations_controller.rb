class OrganizationsController < ApplicationController
  before_action :redirect_if_not_signed_in
  def new
    authorize Organization, :new?
  end

  def create
    authorize Organization, :create?
    organization_name = params[:organization_name].strip
    existing_organization = Organization.where("LOWER(name) = ?", organization_name.downcase).first
    if organization_name.nil? || organization_name.empty?
      redirect_to new_organization_path, alert: I18n.t('controller.organization.create.empty_organization_name_error')
      return
    end
    if !existing_organization.nil?
      redirect_to new_organization_path, alert: I18n.t('controller.organization.create.already_exists_error')
    else
      @organization = Organization.new(name: organization_name)
      if @organization.save
        if params[:image].present?
          @organization.image.attach(params[:image])
        end
      else
        flash[:alert] = I18n.t('controller.organization.something_went_wrong_message')
        redirect_back(fallback_location: root_path)
      end
      @organization = Organization.find_by(name: organization_name)
      UserOrganization.create(user: current_user, organization: @organization, invitation: 'accepted', role: 'admin')
      redirect_to new_organization_path, notice: I18n.t('controller.organization.create.successful_creation_message')
    end
  end

  def show
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :show?
    @user_organizations = UserOrganization.where(organization: @organization)
  end

  def invitations
    authorize Organization, :invitations?
    @user_organizations = UserOrganization.where(user: current_user, invitation: 'pending')
  end

  def invite_people
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :invite_people?
  end

  def add_people
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if !params[:organization][:email].present?
      flash[:alert] = I18n.t('controller.organization.empty_email_error_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :add_people?
    @new_org_user = User.find_by(email: params[:organization][:email])
    if @new_org_user.nil?
      redirect_to invite_people_organization_path, alert: I18n.t('controller.organization.add_people.user_not_exists_message')
    elsif UserOrganization.find_by(user: @new_org_user, organization: @organization).nil?
      UserOrganization.create(user: @new_org_user, organization: @organization, invitation: I18n.t('controller.organization.invitation_status.pending'), role: I18n.t('controller.organization.users_role.non-admin'))
      redirect_to invite_people_organization_path, notice: I18n.t('controller.organization.add_people.invitation_successful_message')
    else
      redirect_to invite_people_organization_path, alert: I18n.t('controller.organization.add_people.user_already_in_organization_message')
    end
  end

  def remove_people
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :remove_people?
    @remove_org_user = User.find_by(id: params[:user_id])
    if !valid_user @remove_org_user
      flash[:alert] = I18n.t('controller.organization.user_does_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if UserOrganization.destroy_by(user: @remove_org_user)
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.remove_people.successfully_removed_message')
    else
      redirect_to organization_path(@organization.id), alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def accept_invitation
    authorize Organization, :accept_invitation?
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    @user_organization = UserOrganization.find_by(user: current_user, organization: @organization)
    if @user_organization.update(invitation: 'accepted')
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.accept_invitation.accepted_message')
    else
      redirect_to organizations_invitations_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def reject_invitation
    @organization = Organization.find_by(id: params[:id])
    authorize Organization, :reject_invitation?
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    @user_organization = UserOrganization.find_by(user: current_user, organization: @organization)
    if @user_organization.update(invitation: I18n.t('controller.organization.invitation_status.rejected'))
      redirect_to organizations_invitations_path, notice: I18n.t('controller.organization.reject_invitation.rejected_message')
    else
      redirect_to organizations_invitations_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def my_organizations
    authorize Organization, :my_organizations?
    @my_organizations = UserOrganization.where(user: current_user, invitation: I18n.t('controller.organization.invitation_status.accepted'))
  end

  def make_admin
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :make_admin?
    @new_admin = User.find_by(id: params[:user_id])
    if !valid_user @new_admin
      flash[:alert] = I18n.t('controller.organization.user_does_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    update_record = UserOrganization.find_by(user: @new_admin, organization: @organization)
    if update_record.update(role: 'admin')
      redirect_to organization_path(@organization.id), notice: I18n.t('controller.organization.make_admin.successful_message')
    else
      redirect_to organization_path(@organization.id), alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def tradings
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :tradings?
    current_month = Time.current.beginning_of_month..Time.current.end_of_month
    @tradings = Trading.where(organization: @organization, created_at: current_month).includes(:user).includes(:organization)
    @comments = Comment.where(organization: @organization, created_at: current_month).includes(:organization)
  end

  def add_trading
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :add_trading?
  end

  def create_trading
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :create_trading?
    if params[:amount].nil? || params[:amount].empty? || params[:amount].blank? || params[:amount]==""
      flash[:alert] = I18n.t('controller.organization.create_trading.empty_amount_error_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Trading.create(user: current_user, organization: @organization, amount: params[:amount])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.create_trading.successful_message')
    else
      redirect_to tradings_organization_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def search_trading
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :search_trading?
  end

  def filtered_tradings
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :filtered_tradings?
    if params[:start_date] > params[:end_date]
      flash[:alert] = I18n.t('controller.organization.filtered_trading.start_date_greater_than_end_date_error')
      redirect_back(fallback_location: root_path)
      return
    end
    start_date = params[:start_date]
    end_date = Date.parse(params[:end_date]).next_day.to_s
    @filtered_tradings = Trading.where(created_at: start_date..end_date)
    @filtered_comments = Comment.where(created_at: start_date..end_date)
  end

  def delete_trading
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :delete_trading?
    if Trading.find_by(id: params[:trading_id]).nil?
      flash[:alert] = I18n.t('controller.organization.delete_trading.trading_not_exits_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Trading.find_by(id: params[:trading_id]).user_id != current_user.id && UserOrganization.find_by(user: current_user).role != I18n.t('controller.organization.users_role.admin')
      flash[:alert] = I18n.t('controller.organization.delete_comment.no_permission_error_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Trading.destroy(params[:trading_id])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.delete_trading.successful_message')
    else
      redirect_to tradings_organization_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def add_comment
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :add_comment?
    if params[:comment].strip.empty?
      flash[:alert] = I18n.t('controller.organization.add_comment.empty_comment_error_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Comment.create(user: current_user, organization: @organization, body: params[:comment])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.add_comment.successful_message')
    else
      redirect_to tradings_organization_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def delete_comment
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :delete_comment?
    if Comment.find_by(id: params[:comment_id]).nil?
      flash[:alert] = I18n.t('controller.organization.delete_comment.comment_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Comment.find_by(id: params[:comment_id]).user_id != current_user.id && UserOrganization.find_by(user: current_user).role != I18n.t('controller.organization.users_role.admin')
      flash[:alert] = I18n.t('controller.organization.delete_comment.no_permission_error_message')
      redirect_back(fallback_location: root_path)
      return
    end
    if Comment.destroy(params[:comment_id])
      redirect_to tradings_organization_path, notice: I18n.t('controller.organization.delete_comment.successful_message')
    else
      redirect_to tradings_organization_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  def delete_organization
    @organization = Organization.find_by(id: params[:id])
    if invalid_organization?
      flash[:alert] = I18n.t('controller.organization.organization_not_exists_message')
      redirect_back(fallback_location: root_path)
      return
    end
    authorize @organization, :delete_organization?
    if Trading.where(organization: @organization).destroy_all && UserOrganization.where(organization: @organization).destroy_all && Comment.where(organization: @organization).destroy_all && Organization.destroy(params[:id])
      redirect_to organizations_my_organizations_path, notice: I18n.t('controller.organization.delete_organization.successful_message')
    else
      redirect_to organizations_my_organizations_path, alert: I18n.t('controller.organization.something_went_wrong_message')
    end
  end

  private

  def invalid_organization?
    return true if @organization.nil?
    return false
  end

  def valid_user(user)
    return false if user.nil?
    return true
  end

  def redirect_if_not_signed_in
    if !user_signed_in?
      redirect_to root_path, alert: I18n.t('controller.application.user_not_logged_in_error')
      return
    end
  end
end
