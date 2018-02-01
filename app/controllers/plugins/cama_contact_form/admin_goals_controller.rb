class Plugins::CamaContactForm::AdminGoalsController < CamaleonCms::Apps::PluginsAdminController
	add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'goal'), :admin_plugins_cama_contact_form_admin_goals_path
	before_action :set_goal, only: ['show','edit','update','destroy']
	def index
		@goals = current_site.goals.order("updated_at desc").page(params[:page])
	end

	def new
		@goal = current_site.goals.new
	end

	def create
		@goal = current_site.goals.new(goal_params)
		if @goal.save
			flash[:notice] = "#{t('.created', default: 'Created successfully')}"
			redirect_to admin_plugins_cama_contact_form_admin_campaigns_path
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @goal.update_attributes(goal_params)
			flash[:notice] = "#{t('.created', default: 'Updated successfully')}"
			redirect_to admin_plugins_cama_contact_form_admin_campaigns_path
		else
			render :edit
		end
	end

	def show
	end

	def destroy
		@goal.destroy
		flash[:notice] = "#{t('.created', default: 'Deleted successfully')}"
		redirect_to admin_plugins_cama_contact_form_admin_campaigns_path
	end

	private
	def set_goal
		begin
      @goal = current_site.goals.find_by_id(params[:id])
    rescue
      flash[:error] = "Error form class"
      redirect_to cama_admin_path
    end
	end

	def goal_params
		params.require(:plugins_cama_contact_form_cama_goal).permit(:name)
	end
end