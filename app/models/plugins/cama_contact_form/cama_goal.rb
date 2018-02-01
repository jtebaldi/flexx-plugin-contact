class Plugins::CamaContactForm::CamaGoal < ActiveRecord::Base
	self.table_name = 'goals'
	belongs_to :site, class_name: "CamaleonCms::Site"
	has_many :campaigns, class_name: "Plugins::CamaContactForm::CamaCampaign", foreign_key: :goal_id, dependent: :destroy

	def successful_campaigns_number
		successful_campaigns_number = 0
		campaigns.each do |c| 
			successful_campaigns_number += c.successful_number
		end
		successful_campaigns_number
	end
end
