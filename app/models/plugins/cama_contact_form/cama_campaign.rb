class Plugins::CamaContactForm::CamaCampaign < ActiveRecord::Base
	self.table_name = 'campaigns'
	belongs_to :site, class_name: "CamaleonCms::Site"

	default_scope { order(created_at: :desc) }

	has_many :campaign_steps, class_name: "Plugins::CamaContactForm::CamaCampaignStep", foreign_key: :campaign_id, dependent: :destroy

	accepts_nested_attributes_for :campaign_steps, allow_destroy: true, reject_if: proc {|field| field[:time_frame].blank?}
end
