class CreateProjectAssignments < ActiveRecord::Migration
  def change
    create_table :project_assignments do |t|
      t.integer :project_membership_id
      t.integer :project_role_id
      t.timestamps
    end
  end
end
