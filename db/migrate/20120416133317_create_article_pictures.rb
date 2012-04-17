class CreateArticlePictures < ActiveRecord::Migration
  def change
    create_table :article_pictures do |t|
      t.string :name 
      t.integer :article_id 
      t.string  :original_image_url
      t.string  :article_image_url
      t.string  :front_page_image_url  # not generated yet. can be pinged 
      t.string :index_image_url 
      
      t.integer  :original_image_size
      t.integer  :article_image_size
      t.integer :front_page_image_size
      t.integer :index_image_size
      
      # there is ordering in the blog post (the full article)
      t.integer :article_display_order, :default => 0
      t.boolean :is_displayed , :default => false 
      
      # is it gonna be displayed@home_page? 
      t.boolean :is_displayed_at_front_page, :default => false 
      
      # is this picture gonna be displayed in the teaser? 
      t.boolean :is_displayed_as_teaser, :default => false
      
      t.boolean  :is_deleted,           :default => false
      t.integer :article_picture_type, :default => ARTICLE_PICTURE_TYPE[:migrated_from_project]
      
      
      t.integer :width
      t.integer :height 
      
      t.integer :article_id 

      t.timestamps
    end
  end
end
