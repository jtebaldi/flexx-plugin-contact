desc "Check campaign"
task :cama_contact_form_campaigns => :environment do
	Plugins::CamaContactForm::CamaContactForm.where.not(:parent_id => nil).each do |contact|
		# puts "#{contact.parent.name} #{contact.created_at}"
		campaign = contact.campaign
		if campaign.present?
			value = (JSON.parse(contact.settings).to_sym rescue contact.value)
			email = value[:fields][contact.parent.fields.select{|f| f[:label].to_s.downcase == "email"}.first[:cid].to_sym]
			puts "#{email} #{contact.created_at} #{contact.campaign.name}"
			contact_campaign = Plugins::CamaContactForm::CamaContactsCampaign.find_or_create_by(campaign_id: campaign.id, contact_id: contact.id)
			if contact_campaign.present?
				campaign.campaign_steps.each do |step|
					send = false
					puts "  Step #{step.time_frame} #{step.time_select} #{step.action_needed}"

					time_now = Time.zone.now
          date_now = time_now.to_date
          t_now = time_now.strftime('%Y-%m-%d-%H')
          schedule_time = (contact.created_at + step.time_frame.to_i.try(step.time_select.downcase.to_sym))
          if step.time_select == "hours"
          	schedule_time = (contact.created_at + step.time_frame.to_i.try(step.time_select.downcase.to_sym)).strftime('%Y-%m-%d-%H')
          	check_time = t_now
          else
          	schedule_time = (contact.created_at + step.time_frame.to_i.try(step.time_select.downcase.to_sym)).strftime('%Y-%m-%d')
          	check_time = date_now
          end
          puts "    #{check_time.to_s} == #{schedule_time.to_s} = #{check_time.to_s == schedule_time.to_s}"
          send = true if check_time.to_s == schedule_time.to_s
					if send
						contact_campaign_step = contact_campaign.campaign_steps.find_or_create_by(step_id: step.id)
					end
				end
			end
		end
	end
end
