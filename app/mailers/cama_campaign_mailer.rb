require 'uri'
class CamaCampaignMailer < ApplicationMailer
  default from: "RYNGER <ryngerco@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cama_campaign_mailer.send_content.subject
  #
  def send_content(contact_email, content, template, campaign_step_id)
    step = Plugins::CamaContactForm::CamaContactsCampaignStep.find(campaign_step_id)
    campaign = step.contacts_campaign.campaign
    site = campaign.site
    @content = content
    admin = CamaleonCms::User.where(role: "admin").first
    if template.file_upload.present?
      begin
        uri = URI.parse(template.file_upload)
        file_name = File.basename(uri.path)
        attachments[file_name] = open(template.file_upload).read
      rescue
        Rails.logger.info "Error on attachment"
      end
    end
    
    mail from: site.get_option('email_from'),to: contact_email, subject: template.name, "X-Mailgun-Variables" => { campaign_step_id: campaign_step_id }.to_json
  end

  def notify_admin(content, subject, campaign_step_id)
  	@content = content
    admin = CamaleonCms::User.where(role: "admin").first
  	mail to: admin.email, subject: "Contact Campaign Notification", "X-Mailgun-Variables" => { campaign_step_id: campaign_step_id }.to_json
  end
end
