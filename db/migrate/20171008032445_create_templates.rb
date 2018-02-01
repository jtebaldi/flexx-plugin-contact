class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :site_id
      t.string :name
      t.string :content

      t.timestamps
    end
  end
end
