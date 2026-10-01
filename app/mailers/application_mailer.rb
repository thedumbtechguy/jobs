class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "Dev Registry <no-reply@example.com>")
  layout "mailer"
end
