class Plugins::CamaContactForm::CamaTemplate < ActiveRecord::Base
	self.table_name = 'templates'
	belongs_to :site, class_name: "CamaleonCms::Site"

	attr_accessor :tmp_content

	def get_content(contact, value)
		current_site = site
		current_theme = site.get_theme
		email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
		name = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "name"}.first[:cid].to_sym]
		content.gsub!("{{contact_name}}", name.titleize)
		content.gsub!("{{contact_email}}", email)

		content.gsub!("{{site_email}}", (current_theme.get_field_value('business_email') rescue ""))
		content.gsub!("{{site_phone}}", (current_theme.get_field_value('business_phone') rescue ""))
		content.gsub!("{{site_address}}", (current_theme.get_field_value('business_address') rescue ""))
		content.gsub!("{{site_logo}}", ActionController::Base.helpers.image_tag(site.get_option('logo')))
		content
	end
end
