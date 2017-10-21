class CamaCampaignMailer < ApplicationMailer
  default from: "RYNGER <ryngerco@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cama_campaign_mailer.send_content.subject
  #
  def send_content(contact_email, content, subject, campaign_step_id)
    @content = content
    admin = CamaleonCms::User.where(role: "admin").first
    mail from: admin.email, to: contact_email, subject: subject, "X-Mailgun-Variables" => { campaign_step_id: campaign_step_id }.to_json
  end

  def notify_admin(content, subject, campaign_step_id)
  	@content = content
    admin = CamaleonCms::User.where(role: "admin").first
  	mail to: admin.email, subject: "Contact Campaign Notification", "X-Mailgun-Variables" => { campaign_step_id: campaign_step_id }.to_json
  end
end
