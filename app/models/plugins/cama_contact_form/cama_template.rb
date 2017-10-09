class Plugins::CamaContactForm::CamaTemplate < ActiveRecord::Base
	self.table_name = 'templates'
	belongs_to :site, class_name: "CamaleonCms::Site"

	attr_accessor :tmp_content
end
