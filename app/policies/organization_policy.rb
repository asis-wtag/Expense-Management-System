class OrganizationPolicy < ApplicationPolicy
  attr :user, :organization
  def initialize(user, organization)
    @user = user
    @organization = organization
  end
  def create?
    true
  end

  def new?
    create?
  end

  def invite_people?
    if UserOrganization.find_by(user: @user, organization: @organization, role: 'admin').nil?
      return false
    else
      return true
    end
  end

  def accept_invitation?
    create?
  end

  def reject_invitation?
    create?
  end

  def my_organizations?
    create?
  end

  def add_people?
    invite_people?
  end

  def show?
    invite_people?
  end

  def invitations?
    create?
  end

  def make_admin?
    invite_people?
  end

  def tradings?
    if UserOrganization.find_by(user: @user, organization: @organization, invitation: 'accepted').nil?
      return false
    else
      return true
    end
  end

  def add_trading?
    tradings?
  end

  def create_trading?
    tradings?
  end

  def delete_trading?
    tradings?
  end

  def add_comment?
    tradings?
  end

  def delete_comment?
    tradings?
  end
end
