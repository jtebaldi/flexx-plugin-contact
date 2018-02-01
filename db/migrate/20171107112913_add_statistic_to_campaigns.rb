class AddStatisticToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :click_count, :integer, default: 0
    add_column :campaigns, :open_count, :integer, default: 0
    add_column :campaigns, :unsubscribe_count, :integer, default: 0
  end
end
