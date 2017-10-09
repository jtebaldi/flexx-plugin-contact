desc "Check campaign"
task :cama_contact_form_campaigns do
  # Task goes here
 	# Plugins::CamaContactForm::CamaCampaign.all.each do |campaign|
 	# 	puts "#{campaign.name}"
	# end
	Plugins::CamaContactForm::CamaContactForm.where.not(:parent_id => nil).each do |contact|
		# puts "#{contact.parent.name} #{contact.created_at}"
		if contact.campaign.present?
			value = (JSON.parse(contact.settings).to_sym rescue contact.value)
			email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
			puts "  #{email} #{contact.created_at} #{contact.campaign.name}"
		end
	end
end
