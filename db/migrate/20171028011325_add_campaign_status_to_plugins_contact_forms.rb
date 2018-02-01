class AddCampaignStatusToPluginsContactForms < ActiveRecord::Migration
  def change
    add_column :plugins_contact_forms, :campaign_status, :string, default: "Active"
    add_column :plugins_contact_forms, :campaign_ended, :boolean, default: false
  end
end
