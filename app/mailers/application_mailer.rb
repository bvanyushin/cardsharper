class ApplicationMailer < ActionMailer::Base
  default from: ENV["CS_DEFAULT_FROM_EMAIL"]
  layout "mailer"
end
