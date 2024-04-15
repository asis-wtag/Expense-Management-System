class OrganizationsController < ApplicationController
  def new
    authorize Organization, :new?
  end
  def create
    authorize Organization, :create?
  end

  def show
    authorize Organization, :show?
  end

  def invitations
    authorize Organization, :invitations?
  end
  def add_people
    @organization = Organization.find(params[:id])
    authorize @organization, :add_people?
  end

  def make_admin
    authorize Organization, :make_admin?
  end

  def add_trading
    authorize Organization, :add_tradings?
  end

  def create_trading
    authorize Organization, :create_trading?
  end

  def delete_trading
    authorize Organization, :delete_trading?
  end

  def create_comment
    authorize Organization, :create_comment?
  end

end
