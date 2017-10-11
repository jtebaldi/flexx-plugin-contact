class Plugins::CamaContactForm::CamaContactsCampaignStep < ActiveRecord::Base
	self.table_name = "contacts_campaign_steps"
	belongs_to :contacts_campaign, class_name: "Plugins::CamaContactForm::CamaContactsCampaign"
	belongs_to :step, class_name: "Plugins::CamaContactForm::CamaCampaignStep"

	after_create :send_content

	def send_content
		step = Plugins::CamaContactForm::CamaCampaignStep.find_by(id: step_id)
		contact = contacts_campaign.contact_form
		if step
			if step.action_needed == "Send email"
				# Send email to contact
				value = (JSON.parse(contact.settings).to_sym rescue contact.value)
				email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
				CamaCampaignMailer.send_content(email, step.template).deliver
			elsif step.action_needed == "Send text"
				# Send text to contact
			elsif step.action_needed == "Notify admin"
				# Notify admin
			end	
		end
	end
end
