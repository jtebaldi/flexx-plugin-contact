class AddIsPublicToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :is_public, :boolean, default: false
  end
end
