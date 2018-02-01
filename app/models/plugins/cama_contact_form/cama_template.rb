class Plugins::CamaContactForm::CamaTemplate < ActiveRecord::Base
	include Plugins::CamaContactForm::MainHelper
	self.table_name = 'templates'
	belongs_to :site, class_name: "CamaleonCms::Site"

	attr_accessor :tmp_content

	def get_content(contact, value)
		current_site = site
		current_theme = site.get_theme
		email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
		name = contact_name(contact, value) rescue ""
		begin
			content.gsub!("{{contact_name}}", name.titleize)
		rescue
		end
		begin
			content.gsub!("{{contact_email}}", email)
		rescue
		end
		begin
			content.gsub!("{{site_name}}", (site.name rescue ""))
		rescue
		end
		begin
			content.gsub!("{{site_email}}", (site.get_option("email_from") rescue ""))
		rescue
		end
		begin
			content.gsub!("{{site_phone}}", (current_theme.get_field_value('business_phone') rescue ""))
		rescue
		end
		begin
			content.gsub!("{{site_address}}", (current_theme.get_field_value('business_address') rescue ""))
		rescue
		end
		begin
			content.gsub!("{{site_logo}}", ActionController::Base.helpers.image_tag(site.get_option('logo')))
		rescue
		end
		content
	end
end
