class AddFrontPageHeightAndWidthToArticlePicture < ActiveRecord::Migration
  def change
    add_column :article_pictures, :front_page_width, :integer
    add_column :article_pictures, :front_page_height, :integer 
    add_column :article_pictures, :is_selected_front_page, :boolean, :default => false 
  end
end
