class CamaCampaignMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cama_campaign_mailer.send_content.subject
  #
  def send_content(contact_email, content, subject)
    @content = content

    mail to: contact_email, subject: subject
  end

  def notify_admin(content, subject)
  	@content = content
    admin = CamaleonCms::User.where(role: "admin").first
  	mail to: admin.email, subject: "Contact Campaign Notification"
  end
end
