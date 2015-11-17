# Use this hook to configure contact mailer.
ContactUs.setup do |config|

  # ==> Mailer Configuration

  # Configure the e-mail address which email notifications should be sent from.  If emails must be sent from a verified email address you may set it here.
  # Example:
  # config.mailer_from = "contact@please-change-me.com"
  config.mailer_from = "playwithyourmind@gmail.com"

  # Configure the e-mail address which should receive the contact form email notifications.
  config.mailer_to = "playwithyourmind@gmail.com"

  # ==> Form Configuration

  # Configure the form to ask for the users name.
  config.require_name = false

  # Configure the form to ask for a subject.
  config.require_subject = true

  # Configure the form gem to use.
  # Example:
  # config.form_gem = 'formtastic'
  config.form_gem = 'formtastic'

  # Configure the redirect URL after a successful submission
  config.success_redirect = '/pages/thanks'

end
