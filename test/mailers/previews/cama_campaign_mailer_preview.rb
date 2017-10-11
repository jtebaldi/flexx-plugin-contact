# Preview all emails at http://localhost:3000/rails/mailers/cama_campaign_mailer
class CamaCampaignMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cama_campaign_mailer/send_content
  def send_content
    CamaCampaignMailer.send_content
  end

end
