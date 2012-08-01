class AddDeliveryMethodToUser < ActiveRecord::Migration
  def change
    add_column :users ,:delivery_method, :integer , :default => NOTIFICATION_DELIVERY_METHOD[:instant]
    add_column :users ,:scheduled_delivery_hours , :string, :default => ""
  end
end
