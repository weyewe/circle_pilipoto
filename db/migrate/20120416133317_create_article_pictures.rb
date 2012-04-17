class CreateArticlePictures < ActiveRecord::Migration
  def change
    create_table :article_pictures do |t|
      
      # t.string   "name"
      #      t.integer  "revision_id"
      #      t.integer  "project_id"
      #      t.string   "original_image_url"
      #      t.string   "index_image_url"
      #      t.string   "revision_image_url"
      #      t.string   "display_image_url"
      #      t.integer  "original_image_size"
      #      t.integer  "index_image_size"
      #      t.integer  "revision_image_size"
      #      t.integer  "display_image_size"
      #      t.boolean  "is_deleted",           :default => false
      #      t.boolean  "is_selected",          :default => false
      #      t.boolean  "is_original",          :default => false
      #      t.boolean  "is_approved"
      #      t.integer  "approved_revision_id"
      #      t.integer  "original_id"
      #      t.integer  "score",                :default => 0
      #      t.integer  "user_id"
      #      t.datetime "created_at",                              :null => false
      #      t.datetime "updated_at",                              :null => false
      #      t.integer  "width"
      #      t.integer  "height"
      #      
      
      t.string :name 
      t.integer :article_id 
      t.string   :original_image_url
      t.string   :index_image_url
      t.string   :revision_image_url
      t.string   :display_image_url
      t.integer  :original_image_size
      t.integer  :index_image_size
      t.integer  :revision_image_size
      t.integer  :display_image_size
      
      # there is ordering in the blog post (the full article)
      t.integer :article_display_order 
      t.boolean :is_displayed , :default => false 
      
      # is it gonna be displayed@home_page? 
      t.boolean :is_displayed_home_page, :default => false 
      
      # is this picture gonna be displayed in the teaser? 
      t.boolean :is_displayed_teaser, :default => false
      
      t.boolean  :is_deleted,           :default => false
      
      
      
      t.integer :width
      t.integer :height 
      
      t.integer :article_id 

      t.timestamps
    end
  end
end
