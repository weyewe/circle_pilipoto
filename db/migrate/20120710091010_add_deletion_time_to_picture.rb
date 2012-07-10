class AddDeletionTimeToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :deletion_time, :datetime 
    add_column :article_pictures, :deletion_time, :datetime 
  end
end
