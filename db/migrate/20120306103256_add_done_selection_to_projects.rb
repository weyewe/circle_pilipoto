class AddDoneSelectionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :done_with_selection, :boolean, :default => false 
  end
end
