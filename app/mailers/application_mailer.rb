class ApplicationMailer < ActionMailer::Base
  default from: I18n.t('mailer.default_address')
  layout I18n.t('mailer.default_layout')
end
