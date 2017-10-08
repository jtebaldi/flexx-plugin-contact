class AddCampaignIdToPluginsContactForms < ActiveRecord::Migration
  def change
    add_column :plugins_contact_forms, :campaign_id, :integer
  end
end
