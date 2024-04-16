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

  def add_people?
    invite_people?
  end

  def show?
    create?
  end

  def invitations?
    create?
  end

  def make_admin?
    invite_people?
  end

  def add_trading?
    invite_people?
  end

  def create_trading?
    invite_people?
  end

  def delete_trading?
    invite_people?
  end

  def create_comment?
    invite_people?
  end
end
