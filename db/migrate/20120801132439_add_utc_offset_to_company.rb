class AddUtcOffsetToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :utc_offset, :integer
    add_column :companies, :time_zone, :string
    remove_column :companies, :string
    remove_column :companies, :integer 
  end
end
