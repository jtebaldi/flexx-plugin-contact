class Plugins::CamaContactForm::CamaContactsCampaign < ActiveRecord::Base
	self.table_name = "contacts_campaigns"
	belongs_to :campaign, class_name: "Plugins::CamaContactForm::CamaCampaign"
	belongs_to :contact_form, class_name: "Plugins::CamaContactForm::CamaContactForm", foreign_key: :contact_id
	has_many :campaign_steps, class_name: "Plugins::CamaContactForm::CamaContactsCampaignStep", dependent: :destroy, foreign_key: :contacts_campaign_id
end
