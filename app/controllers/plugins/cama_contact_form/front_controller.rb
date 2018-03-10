class Plugins::CamaContactForm::FrontController < CamaleonCms::Apps::PluginsFrontController
  include Plugins::CamaContactForm::MainHelper
  include Plugins::CamaContactForm::ContactFormControllerConcern

  before_action :verify_google_captcha, only: [:save_form]

  # here add your custom functions
  def save_form
    flash[:contact_form] = {}
    @form = current_site.contact_forms.find_by_id(params[:id])
    fields = params[:fields]
    errors = []
    success = []

    args = {form: @form, values: fields, flag: true}; hooks_run("contact_form_before_submit", args)
    if args[:flag]
      perform_save_form(@form, fields, success, errors)
      if success.present?
        flash[:contact_form][:notice] = success.join('<br>')
      else
        flash[:contact_form][:error] = errors.join('<br>')
        flash[:values] = fields.delete_if{|k, v| v.class.name == 'ActionDispatch::Http::UploadedFile' }
      end
    end
    respond_to do |format|
      format.html do
        if @form.the_settings[:railscf_redirect][:enabled] == "true" && @form.the_settings[:railscf_redirect][:url].present?
          redirect_to @form.the_settings[:railscf_redirect][:url]
        else
          redirect_to request.referrer
        end
      end
      format.json { render(json: flash.discard(:contact_form).to_hash) }
      format.js do
        @message = flash[:contact_form]
      end
    end
  end

  private

  def verify_google_captcha
    form = current_site.contact_forms.find_by_id(params[:id])
    fields = JSON.parse(form.value)["fields"]
    recaptcha_index = fields.index {|f| f["label"] == "Recaptcha" }

    if recaptcha_index
      unless params["g-recaptcha-response"].present? && GoogleCaptchaValidator.validate(params["g-recaptcha-response"])
        flash[:contact_form] = { error: "Invalid captcha! Please, try again." }
        params[:format] == 'json' ? render(json: flash.discard(:contact_form).to_hash) : (redirect_to :back)
      end
    end
  end

end
