module Plugins::CamaContactForm::ContactFormControllerConcern
  require 'twilio-ruby'

  def perform_save_form(form, fields, success, errors)
    @the_form = form
    attachments = []
    if validate_to_save_form(form, fields, errors)
      form.fields.each do |f|
        if f[:field_type] == 'file'
          file_paths = []
          fields[f[:cid].to_sym].each do |file|
            res = cama_tmp_upload(file, {
                maximum: current_site.get_option('filesystem_max_size', 100).megabytes,
                path: Rails.public_path.join("contact_form", current_site.id.to_s),
                name: file.original_filename
              }
            )
            if res[:error].present?
              errors << res[:error].to_s.translate
            else
              attachments << res[:file_path]
              file_paths << res[:file_path].sub(Rails.public_path.to_s, cama_root_url)
            end
          end
          fields[f[:cid].to_sym] = file_paths
        end
      end
      new_settings = {"fields" => fields, "created_at" => Time.current.strftime("%Y-%m-%d %H:%M:%S").to_s}.to_json
      form_new = current_site.contact_forms.new(name: "response-#{Time.now}", description: form.description, settings: new_settings, site_id: form.site_id, parent_id: form.id)
      if form_new.save
        fields_data = convert_form_values(form, fields)
        message_body = form.the_settings[:railscf_mail][:body].to_s.translate.cama_replace_codes(fields)
        content = render_to_string(partial: plugin_view('contact_form/email_content'), layout: false, formats: ['html'], locals: {file_attachments: attachments, fields: fields_data, values: fields, message_body: message_body, form: form})
        cama_send_email(form.the_settings[:railscf_mail][:to], form.the_settings[:railscf_mail][:subject].to_s.translate.cama_replace_codes(fields), {attachments: attachments, content: content, extra_data: {fields: fields_data}})

        if form.the_settings[:railscf_twilio][:enabled] == "true"
          # byebug
          lead_data = fields_data
          send_message(lead_data)
        end

        success << form.the_message('mail_sent_ok', t('.success_form_val', default: 'Your message has been sent successfully. Thank you very much!'))
        args = {form: form, values: fields, form_received: form_new}; hooks_run("contact_form_after_submit", args)
        if form.the_settings[:railscf_mail][:to_answer].present? && (answer_to = fields[form.the_settings[:railscf_mail][:to_answer].gsub(/(\[|\])/, '').to_sym]).present?
          content = form.the_settings[:railscf_mail][:body_answer].to_s.translate.cama_replace_codes(fields)
          cama_send_email(answer_to, form.the_settings[:railscf_mail][:subject_answer].to_s.translate.cama_replace_codes(fields), {content: content})
        end
      else
        errors << form.the_message('mail_sent_ng', t('.error_form_val', default: 'An error occurred, please try again.'))
      end
    end
  end

  # form validations
  def validate_to_save_form(form, fields, errors)
    validate = true
    form.fields.each do |f|
      next if f[:field_type] == 'stripe'
      cid = f[:cid].to_sym
      label = f[:label].to_sym
      case f[:field_type].to_s
        when 'text', 'website', 'paragraph', 'textarea', 'email', 'radio', 'checkboxes', 'dropdown', 'file'
          if f[:required].to_s.cama_true? && !fields[cid].present?
            errors << "#{label.to_s.translate}: #{form.the_message('invalid_required', t('.error_validation_val', default: 'This value is required'))}"
            validate = false
          end
          if f[:field_type].to_s == 'email'
            unless fields[cid].match(/@/)
              errors << "#{label.to_s.translate}: #{form.the_message('invalid_email', t('.email_invalid_val', default: 'The e-mail address appears invalid'))}"
              validate = false
            end
          end
        when 'captcha'
          unless cama_captcha_verified?
            errors << "#{label.to_s.translate}: #{form.the_message('captcha_not_match', t('.captch_error_val', default: 'The entered code is incorrect'))}"
            validate = false
          end
      end
    end
    validate
  end

  # form values with labels + values to save
  def convert_form_values(form, fields)
    values = {}
    form.fields.each do |field|
      next unless relevant_field?(field)
      ft = field[:field_type]
      cid = field[:cid].to_sym
      label = values.keys.include?(field[:label]) ? "#{field[:label]} (#{cid})" : field[:label].to_s.translate
      values[label] = []
      if ft == 'file'
        nr_files = fields[cid].size
        values[label] << "#{nr_files} #{"file".pluralize(nr_files)} (attached)" if fields[cid].present?
      elsif ft == 'radio' || ft == 'checkboxes'
        values[label] << fields[cid].map { |f| f.to_s.translate }.join(', ') if fields[cid].present?
      else
        values[label] << fields[cid] if fields[cid].present?
      end
    end
    values
  end

  def relevant_field?(field)
    !%w(captcha submit button stripe twilio).include? field[:field_type]
  end

  private

  def send_message(lead)
    twilio_sid = ENV['TWILIO_SID']
    twilio_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new(twilio_sid, twilio_token)

    to_phones = []
    phone = @the_form.the_settings[:railscf_twilio][:phone].presence || current_site.get_field("twilio_default-number")
    to_phones << "+1#{phone}"

    @twilio_number = ENV['TWILIO_FROM_NUMBER']

    to_phones.each do |agent|
      message = @client.messages.create(
        from:  @twilio_number,
        to:    agent,
        body:  "New lead!\n" + lead.map{ |k,v| "#{k}: #{v.first}\n" }.join('')
      )

      puts message.to
    end

  end
end
