class CreateCampaignSteps < ActiveRecord::Migration
  def change
    create_table :campaign_steps do |t|
      t.references :campaign, index: true
      t.integer :time_frame
      t.string :time_select
      t.string :action_needed
      t.references :template, index: true

      t.timestamps
    end
  end
end
