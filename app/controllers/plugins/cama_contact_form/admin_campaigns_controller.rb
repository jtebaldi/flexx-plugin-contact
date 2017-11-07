class Plugins::CamaContactForm::AdminCampaignsController < CamaleonCms::Apps::PluginsAdminController
	add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'Campaign'), :admin_plugins_cama_contact_form_admin_campaigns_path
	before_action :set_campaign, only: ['show','edit','update','destroy']
	skip_before_filter :cama_site_check_existence, only: [:mailgun_callback, :twilio_callback]
	skip_before_filter :cama_authenticate, only: [:mailgun_callback, :twilio_callback]
	skip_before_filter :verify_authenticity_token, only: [:mailgun_callback, :twilio_callback]
	def index
		@campaigns = current_site.campaigns.order("updated_at desc").page(params[:page])
		@goals = current_site.goals.order("updated_at desc")
	end

	def new
		@campaign = current_site.campaigns.new
	end

	def create
		@campaign = current_site.campaigns.new(campaign_params)
		if @campaign.save
			flash[:notice] = "#{t('.created', default: 'Created successfully')}"
			redirect_to action: :index
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @campaign.update_attributes(campaign_params)
			flash[:notice] = "#{t('.created', default: 'Updated successfully')}"
			redirect_to action: :index
		else
			render :edit
		end
	end

	def show
	end

	def destroy
		@campaign.destroy
		flash[:notice] = "#{t('.created', default: 'Deleted successfully')}"
		redirect_to action: :index
	end

	def mailgun_callback
		Rails.logger.info "MAILGUN: #{params.inspect}"
    begin
      @email_event = Plugins::CamaContactForm::CamaContactsCampaignStep.find params["campaign_step_id"]
      @email_event.status = params[:event].to_s.titleize
      @email_event.save
      if params[:event].to_s == "unsubscribed"
      	@contact_form = @email_event.contacts_campaign.contact_form
      	@contact_form.campaign_ended = true
      	@contact_form.campaign_status = "Unsubscribed"
      	@contact_form.save
      end
      @campaign = @contact_form.contacts_campaign.campaign
      if params[:event].to_s == "unsubscribed"
      	@campaign.unsubscribe_count += 1
      elsif params[:event].to_s == "opened"
      	@campaign.open_count += 1
      elsif params[:event].to_s == "clicked"
      	@campaign.click_count += 1
      end
      @campaign.save
    rescue Exception => e
      Rails.logger.info "Email Tracking error: #{e}"
    end
    render text: "ok"
	end

	def twilio_callback
		begin
      @text_event = Plugins::CamaContactForm::CamaContactsCampaignStep.find params["campaign_step_id"]
      @text_event.status = params["SmsStatus"].to_s.titleize
      @text_event.save
    rescue Exception => e
      Rails.logger.info "Text Tracking error: #{e}"
    end
		render text: "ok"
	end

	private
	def set_campaign
		begin
      @campaign = current_site.campaigns.find_by_id(params[:id])
    rescue
      flash[:error] = "Error form class"
      redirect_to cama_admin_path
    end
	end

	def campaign_params
		params.require(:plugins_cama_contact_form_cama_campaign).permit(:name, :description, :goal_id, campaign_steps_attributes: [:id, :time_frame, :time_select, :action_needed, :template_id, :_destroy])
	end
end