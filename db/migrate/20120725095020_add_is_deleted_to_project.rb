class AddIsDeletedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :is_deleted, :boolean, :default => false 
  end
end
