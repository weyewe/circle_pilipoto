class AddArticleDisplayImageToPictures < ActiveRecord::Migration
  def change
    add_column :pictures,  :front_page_article_image_url ,:string
    add_column :pictures,  :front_page_article_image_size ,:integer
  end
end
