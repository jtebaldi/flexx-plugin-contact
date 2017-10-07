class Plugins::CamaContactForm::CamaCampaign < ActiveRecord::Base
	self.table_name = 'campaigns'
	belongs_to :site, class_name: "CamaleonCms::Site"

	default_scope { order(created_at: :desc) }
end
