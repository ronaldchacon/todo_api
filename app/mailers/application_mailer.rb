class ApplicationMailer < ActionMailer::Base
  default from: "admin@todo.com"
  layout "mailer"
end
