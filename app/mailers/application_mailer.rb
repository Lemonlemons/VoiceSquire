class ApplicationMailer < ActionMailer::Base
  default from: "confirm@usesquire.com"
  layout 'mailer'
end
