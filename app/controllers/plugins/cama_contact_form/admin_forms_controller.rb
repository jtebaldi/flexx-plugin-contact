class Plugins::CamaContactForm::AdminFormsController < CamaleonCms::Apps::PluginsAdminController
  include Plugins::CamaContactForm::MainHelper
  include Plugins::CamaContactForm::ContactFormControllerConcern
  before_action :set_form, only: ['show','edit','update','destroy', :change_campaign, :update_campaign, :end_campaign, :update_end_campaign, :save_fields]
  add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'Contact Form'), :admin_plugins_cama_contact_form_admin_forms_path, except: [:leads]
  helper_method :sort_column, :sort_direction

  def index
    @forms = current_site.contact_forms.where("parent_id is null").all
    @forms = @forms.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
  end

  def edit
    add_breadcrumb I18n.t("plugins.cama_contact_form.edit_view", default: 'Edit contact form')
    render "edit"
  end

  def show
    add_breadcrumb I18n.t("plugins.cama_contact_form.lead", default: 'Lead')
    @form = current_site.contact_forms.find(params[:id])
    values = JSON.parse(@form.parent.value).to_sym
    @value = (JSON.parse(@form.settings).to_sym rescue @form.value)
    @op_fields = values[:fields].select{ |field| relevant_field? field }
  end

  def update
    if @form.update(params.require(:plugins_cama_contact_form_cama_contact_form).permit(:name, :slug))
      settings = {"railscf_mail" => params[:railscf_mail], "railscf_message" => params[:railscf_message], "railscf_form_button" => params[:railscf_form_button], "railscf_campaign" => params[:railscf_campaign]}
      fields = []
      (params[:fields] || {}).each{|k, v|
        v[:field_options][:options] = v[:field_options][:options].values if v[:field_options][:options].present?
        fields << v
      }
      @form.update({settings: settings.to_json, value: {fields: fields}.to_json})
      flash[:notice] = t('.updated_success', default: 'Updated successfully')
      redirect_to action: :edit, id: @form.id
    else
      edit
    end
  end

  def create
    @form = current_site.contact_forms.new(params.require(:plugins_cama_contact_form_cama_contact_form).permit(:name, :slug))
    if @form.save
      flash[:notice] = "#{t('.created', default: 'Created successfully')}"
      redirect_to action: :edit, id: @form.id
    else
      flash[:error] = @form.errors.full_messages.join(', ')
      redirect_to action: :index
    end
  end

  def destroy
    flash[:notice] = "#{t('.deleted', default: 'Destroyed successfully')}" if @form.destroy
    redirect_to action: :index
  end

  def responses
    add_breadcrumb I18n.t("plugins.cama_contact_form.list_responses", default: 'Contact form records')
    @form = current_site.contact_forms.where({id: params[:admin_form_id]}).first
    values = JSON.parse(@form.value).to_sym
    @op_fields = values[:fields].select{ |field| relevant_field? field }
    @forms = current_site.contact_forms.where({parent_id: @form.id})
    @forms = @forms.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
  end

  def leads
    add_breadcrumb I18n.t("plugins.cama_contact_form.title", default: 'Leads'), :admin_plugins_cama_contact_form_admin_forms_path
    add_breadcrumb I18n.t("plugins.cama_contact_form.leads", default: 'Prospects')
    @forms = current_site.contact_forms.includes([:campaign, :parent]).where.not({parent_id: nil})
    if params[:contact_form_id].present?
      @forms = @forms.where(parent_id: params[:contact_form_id])
    end
    if params[:campaign_id].present?
      @forms = @forms.where(campaign_id: params[:campaign_id])
    end
    @forms = @forms.order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => current_site.admin_per_page)
  end

  def del_response
    response = current_site.contact_forms.find_by_id(params[:response_id])
    if response.present? && response.destroy
      flash[:notice] = "#{t('.actions.msg_deleted', default: 'The response has been deleted')}"
    end
    redirect_to request.referrer
  end

  def manual

  end

  def change_campaign
  end

  def end_campaign
  end

  def update_end_campaign
    @form.update_attributes(form_campaign_params)
  end

  def save_fields
    @form.settings = JSON.parse(@form.settings).merge(params[:plugins_contact_form][:value]) {|key, oldval, newval| newval }.to_json
    @form.save
    redirect_to action: :show
  end

  def update_campaign
    @form.assign_attributes(form_campaign_params)
    if @form.campaign_id_changed?
      @form.created_at = Time.zone.now
    end
    @form.save
  end

  def item_field
    render partial: 'item_field', locals:{ field_type: params[:kind], cid: params[:cid] }
  end

  # here add your custom functions
  private
  def set_form
    begin
      @form = current_site.contact_forms.find_by_id(params[:id])
    rescue
      flash[:error] = "Error form class"
      redirect_to cama_admin_path
    end
  end

  def form_campaign_params
    params.require(:plugins_cama_contact_form_cama_contact_form).permit(:campaign_id, :campaign_status, :campaign_ended)
  end

  def form_fields_params
    # params.require(:plugins_contact_form).permit(:value)
  end

  # sort column, default is filename
  def sort_column
    params[:sort] || "created_at"
  end
  
  # sort direction
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
