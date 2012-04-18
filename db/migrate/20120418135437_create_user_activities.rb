class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.string   :subject_type
      t.string   :actor_type
      t.string   :secondary_subject_type
      t.integer  :subject_id
      t.integer  :actor_id
      t.integer  :secondary_subject_id
      t.boolean  :is_notification_sent,   :default => false
      t.integer  :event_type
      
      
      # we need these 2 to extract email recipients
      t.integer :project_id 
      t.integer :actor_role_id 

      t.timestamps
    end
  end
end
