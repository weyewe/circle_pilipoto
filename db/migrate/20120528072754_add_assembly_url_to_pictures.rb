class AddAssemblyUrlToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :assembly_url, :text
    add_column :pictures, :is_completed, :boolean, :default => true
  end
end
