class AddGoalIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :goal_id, :integer
  end
end
