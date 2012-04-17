class AddWidthAndHeightToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :width, :integer
    add_column :pictures, :height, :integer
  end
end
