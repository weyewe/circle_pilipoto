class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title 
      t.text :description
      t.text :teaser 
      t.integer :project_id 
      
      t.integer :company_id 
      t.integer :user_id 
      
      t.integer :article_type , :default => ARTICLE_TYPE[:mapped_from_project]
      
      t.boolean :has_front_page_image, :default => false 
      
      t.integer :article_category_id 
      t.timestamps
    end
  end
end
