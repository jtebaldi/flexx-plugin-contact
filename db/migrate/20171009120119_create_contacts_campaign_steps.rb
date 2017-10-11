class CreateContactsCampaignSteps < ActiveRecord::Migration
  def change
    create_table :contacts_campaign_steps do |t|
      t.integer :contacts_campaign_id
      t.integer :step_id
      t.string :status, default: "Created"

      t.timestamps null: false
    end
  end
end
