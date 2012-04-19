class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description 
      t.integer :owner_id #project_owner id 
      t.integer :picture_select_quota 
      
      t.boolean :is_private , :default => false 
      t.boolean :is_locked, :default => false 
      
      t.integer :company_id 
      
      t.timestamps
    end
  end
end
