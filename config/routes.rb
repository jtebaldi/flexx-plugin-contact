Rails.application.routes.draw do

    scope PluginRoutes.system_info["relative_url_root"] do
      scope '(:locale)', locale: /#{PluginRoutes.all_locales}/, :defaults => {  } do
        # frontend
        namespace :plugins do
          namespace 'cama_contact_form' do
            post 'save_form' => "front#save_form"
          end
        end
      end

      #Admin Panel
      scope :admin, as: 'admin', path: PluginRoutes.system_info['admin_path_name'] do
        namespace 'plugins' do
          namespace 'cama_contact_form' do
            post :mailgun_callback, to: "admin_campaigns#mailgun_callback", as: :mailgun_callback
            post "twilio_callback/:campaign_step_id", to: "admin_campaigns#twilio_callback", as: :twilio_callback
            resources :admin_forms  do
              delete 'del_response'
              get 'responses'
              get 'item_field', on: :collection
              member do
                get :change_campaign
                put :update_campaign
                get :end_campaign
                put :update_end_campaign
              end
            end

            resources :admin_campaigns
            resources :admin_goals
            resources :admin_templates
            get :leads, to: "admin_forms#leads"
          end
        end
      end
    end
  end
