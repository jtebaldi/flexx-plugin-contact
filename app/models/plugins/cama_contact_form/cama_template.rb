class Plugins::CamaContactForm::CamaTemplate < ActiveRecord::Base
	self.table_name = 'templates'
	belongs_to :site, class_name: "CamaleonCms::Site"

	attr_accessor :tmp_content

	def get_content(contact, value)
		email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
		name = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "name"}.first[:cid].to_sym]
		content.gsub!("{{contact_name}}", name.titleize)
		content.gsub!("{{contact_email}}", email)
		content
	end
end
