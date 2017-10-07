class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.integer :site_id
      t.timestamps
    end
  end
end
