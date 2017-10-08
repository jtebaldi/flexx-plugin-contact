Rails.application.config.to_prepare do
  CamaleonCms::Site.class_eval do
    has_many :contact_forms, :class_name => "Plugins::CamaContactForm::CamaContactForm", foreign_key: :site_id, dependent: :destroy
    has_many :campaigns, :class_name => "Plugins::CamaContactForm::CamaCampaign", foreign_key: :site_id, dependent: :destroy
    has_many :goals, :class_name => "Plugins::CamaContactForm::CamaGoal", foreign_key: :site_id, dependent: :destroy
    has_many :templates, :class_name => "Plugins::CamaContactForm::CamaTemplate", foreign_key: :site_id, dependent: :destroy
  end
end