class OrganizationPolicy < ApplicationPolicy
  def create?
    true
  end

  def new?
    create?
  end

  def add_people?
    UserOrganization.exists?(user: @user, organization: @organization, role: 'admin')
  end

  def show?
    create?
  end

  def invitations?
    create?
  end

  def make_admin?
    add_people?
  end

  def add_trading?
    add_people?
  end

  def create_trading?
    add_people?
  end

  def delete_trading
    add_people?
  end

  def create_comment
    add_people?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def initialize(user, organization)
      @user = user
      @organization = organization
    end
  end
end
