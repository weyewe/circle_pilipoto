class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :facebook_link
      t.string :twitter_link
      t.string :linkedin_link
      
      t.string :name 
      t.string :phone_number
      t.string :contact_email 
      t.string :website_address
      
      t.text :office_address
      
      t.integer  :delivery_method,       :integer,     :default => NOTIFICATION_DELIVERY_METHOD[:instant]
      t.string   :scheduled_delivery_hours, :string  , :default => ""

      t.timestamps
    end
  end
end
