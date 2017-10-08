class Plugins::CamaContactForm::AdminTemplatesController < CamaleonCms::Apps::PluginsAdminController
	add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'template'), :admin_plugins_cama_contact_form_admin_templates_path
	before_action :set_template, only: ['show','edit','update','destroy']
	def index
		@templates = current_site.templates.order("updated_at desc").page(params[:page])
	end

	def new
		@template = current_site.templates.new
	end

	def create
		@template = current_site.templates.new(template_params)
		if @template.save
			flash[:notice] = "#{t('.created', default: 'Created successfully')}"
			redirect_to action: :index
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @template.update_attributes(template_params)
			flash[:notice] = "#{t('.created', default: 'Updated successfully')}"
			redirect_to action: :index
		else
			render :edit
		end
	end

	def show
	end

	def destroy
		@template.destroy
		flash[:notice] = "#{t('.created', default: 'Deleted successfully')}"
		redirect_to action: :index
	end

	private
	def set_template
		begin
      @template = current_site.templates.find_by_id(params[:id])
    rescue
      flash[:error] = "Error form class"
      redirect_to cama_admin_path
    end
	end

	def template_params
		params.require(:plugins_cama_contact_form_cama_template).permit(:name)
	end
end