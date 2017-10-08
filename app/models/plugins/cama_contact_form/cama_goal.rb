class Plugins::CamaContactForm::CamaGoal < ActiveRecord::Base
	self.table_name = 'goals'
	belongs_to :site, class_name: "CamaleonCms::Site"
end
