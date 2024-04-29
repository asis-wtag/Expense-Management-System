class ExpenseMailer < ApplicationMailer
  def monthly_expense_report(user, organization, net_expense)
    @user = user
    @organization = organization
    @net_expense = net_expense
    mail(to: user.email, subject: I18n.t('mailer.expense_mailer.subject', organization_name: organization.name))
  end
end
