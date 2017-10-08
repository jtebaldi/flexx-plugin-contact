class Plugins::CamaContactForm::CamaTemplate < ActiveRecord::Base
	self.table_name = 'templates'
	belongs_to :site, class_name: "CamaleonCms::Site"
end
