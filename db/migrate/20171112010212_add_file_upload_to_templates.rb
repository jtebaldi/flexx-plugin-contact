class AddFileUploadToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :file_upload, :text
  end
end
