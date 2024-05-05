require 'date'
class ReportJob
  include Sidekiq::Job

  # def perform
  #   current_month = Date.today.prev_month.beginning_of_month..Date.today.beginning_of_month
  #   organizations = Organization.all
  #   organizations.each do |organization|
  #     tradings = Trading.where(organization: organization, created_at: current_month)
  #     net_expense = tradings.sum(:amount)
  #     user_organizations = UserOrganization.where(organization: organization, invitation: 'accepted').includes(:user)
  #     user_organizations.each do |user_organization|
  #       ExpenseMailer.monthly_expense_report(user_organization.user, user_organization.organization, net_expense).deliver_later
  #     end
  #   end
  # end

  def perform
    current_month = Date.today.beginning_of_month..Date.today.end_of_month
    organizations = Organization.all
    organizations.each do |organization|
      tradings = Trading.where(organization: organization, created_at: current_month)
      net_expense = tradings.sum(:amount)
      user_organizations = UserOrganization.where(organization: organization, invitation: 'accepted').includes(:user)
      user_organizations.each do |user_organization|
        ExpenseMailer.monthly_expense_report(user_organization.user, user_organization.organization, net_expense).deliver_later
      end
    end
  end
end
