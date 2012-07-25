class AddIndexWidthAndHeightToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :index_width, :integer
    add_column :pictures, :index_height, :integer
  end
end
