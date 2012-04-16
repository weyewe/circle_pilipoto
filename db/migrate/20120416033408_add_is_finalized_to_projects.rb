class AddIsFinalizedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_finalized, :boolean, :default => false 
  end
end
