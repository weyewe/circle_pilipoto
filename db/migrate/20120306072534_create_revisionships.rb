class CreateRevisionships < ActiveRecord::Migration
  def change
    create_table :revisionships do |t|
      t.integer :picture_id
      t.integer :revision_id
      
      t.timestamps
    end
  end
end
