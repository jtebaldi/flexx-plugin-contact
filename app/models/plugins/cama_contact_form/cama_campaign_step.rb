class Plugins::CamaContactForm::CamaCampaignStep < ActiveRecord::Base
	self.table_name = 'campaign_steps'
  belongs_to :campaign, class_name: "Plugins::CamaContactForm::CamaCampaign", foreign_key: :campaign_id
  belongs_to :template
end
