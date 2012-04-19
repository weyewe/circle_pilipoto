class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer  :company_id
      t.integer  :user_id
      t.string   :enrollment_code
      t.boolean :is_current_perspective , :default => true 
      
      # we don't delete enrollemnt. we deactivate it
      t.boolean :is_active, :default => true 
      
      t.timestamps
    end
  end
end
