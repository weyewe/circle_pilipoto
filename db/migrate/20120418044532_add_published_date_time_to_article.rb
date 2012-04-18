class AddPublishedDateTimeToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :publication_datetime, :datetime 
  end
end
