class CamaCampaignMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cama_campaign_mailer.send_content.subject
  #
  def send_content(contact_email, template)
    @content = template.content

    mail to: contact_email, subject: template.name
  end

  def notify_admin(content)
  	@content = content
  	mail to: "admin@example.com", subject: "Contact Campaign Notification"
  end
end
