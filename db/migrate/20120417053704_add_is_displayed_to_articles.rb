class AddIsDisplayedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_displayed, :boolean, :default => false 
  end
end
