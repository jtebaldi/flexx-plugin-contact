class Plugins::CamaContactForm::AdminCampaignsController < CamaleonCms::Apps::PluginsAdminController
	add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'Campaign'), :admin_plugins_cama_contact_form_admin_campaigns_path
	before_action :set_campaign, only: ['show','edit','update','destroy']
	def index
		@campaigns = current_site.campaigns.order("updated_at desc").page(params[:page])
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
		params.require(:plugins_cama_contact_form_cama_campaign).permit(:name, :description)
	end
end