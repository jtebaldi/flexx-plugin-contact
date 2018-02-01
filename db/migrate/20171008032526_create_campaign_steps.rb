class CreateCampaignSteps < ActiveRecord::Migration
  def change
    create_table :campaign_steps do |t|
      t.references :campaign, index: true
      t.integer :time_frame, default: 1
      t.string :time_select, default: "days"
      t.string :action_needed, default: "Send email"
      t.references :template, index: true

      t.timestamps
    end
  end
end
