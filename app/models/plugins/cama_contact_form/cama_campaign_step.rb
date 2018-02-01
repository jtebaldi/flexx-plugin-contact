class Plugins::CamaContactForm::CamaCampaignStep < ActiveRecord::Base
	self.table_name = "campaign_steps"
	belongs_to :campaign, class_name: "Plugins::CamaContactForm::CamaCampaign"
	belongs_to :template, class_name: "Plugins::CamaContactForm::CamaTemplate"
	has_many :contacts_campaign_steps, class_name: "Plugins::CamaContactForm::CamaContactsCampaignStep", foreign_key: :step_id, dependent: :destroy
end
