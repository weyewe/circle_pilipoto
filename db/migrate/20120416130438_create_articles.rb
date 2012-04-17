class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title 
      t.text :description
      t.text :teaser 
      t.integer :project_id 
      
      
      t.integer :article_type , :default => ARTICLE_TYPE[:mapped_from_project]
      
      
      t.integer :article_category_id 
      t.timestamps
    end
  end
end
