class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      
      t.string   :name
      t.integer  :revision_id
      t.integer  :project_id
      t.string   :original_image_url
      t.string   :index_image_url
      t.string   :revision_image_url
      t.string   :display_image_url
      t.integer  :original_image_size
      t.integer  :index_image_size
      t.integer  :revision_image_size 
      t.integer  :display_image_size
      t.boolean  :is_deleted ,            :default => false
      t.boolean  :is_selected ,           :default => false
      t.boolean  :is_original ,           :default => false
      t.boolean  :is_approved
      t.integer  :approved_revision_id
      t.integer  :original_id
      t.integer  :score,                 :default => 0
      t.integer   :user_id  # the uploader 
        

      t.timestamps
    end
  end
end
