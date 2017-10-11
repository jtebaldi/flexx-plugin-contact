class CreateContactsCampaigns < ActiveRecord::Migration
  def change
    create_table :contacts_campaigns do |t|
      t.integer :campaign_id
      t.integer :contact_id

      t.timestamps null: false
    end
  end
end
