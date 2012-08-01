class AddUtcOffsetToUser < ActiveRecord::Migration
  def change
    add_column :users, :utc_offset, :integer
    add_column :users, :time_zone, :string
  end
end
