class Plugins::CamaContactForm::CamaContactsCampaignStep < ActiveRecord::Base
	require 'twilio-ruby'
	self.table_name = "contacts_campaign_steps"
	belongs_to :contacts_campaign, class_name: "Plugins::CamaContactForm::CamaContactsCampaign"
	belongs_to :step, class_name: "Plugins::CamaContactForm::CamaCampaignStep"

	after_create :send_content

	def send_content
		step = Plugins::CamaContactForm::CamaCampaignStep.find_by(id: step_id)
		contact = contacts_campaign.contact_form
		value = (JSON.parse(contact.settings).to_sym rescue contact.value)
		contact_email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
		contact_name = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
		if step
			if step.action_needed == "Send email"
				# Send email to contact
				CamaCampaignMailer.send_content(contact_email, step.template.get_content(contact, value), step.template.name, self.id).deliver
			elsif step.action_needed == "Send text"
				# Send text to contact
				send_message(contact, contact_name, contact_email)
			elsif step.action_needed == "Notify admin"
				# Notify admin
				CamaCampaignMailer.notify_admin(step.template.get_content(contact, value), step.template.name, self.id).deliver
			end	
		end
	end

	def send_message(contact, contact_name, contact_email)
    twilio_sid = ENV['TWILIO_SID']
    twilio_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new(twilio_sid, twilio_token)
     
    to_phones = []
    to_phones << "+1" + contact.site.get_field("twilio_default-number")
    
    @twilio_number = ENV['TWILIO_FROM_NUMBER']
    
    if opts == "text"
        to_phones.each do |agent|
            message = @client.account.messages.create(
              from:  @twilio_number,
              to:    agent,
              body:  "Campaign notification from #{contact_name} #{contact_email}"
            )
        end
    end
  end
end
