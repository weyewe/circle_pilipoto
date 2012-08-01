class PolledDelivery < ActiveRecord::Base
  def self.clear_all_pending_delivery( user ) 
    # puts "Ahahaha, we are good. The shchool is #{school}"
    
    pending_deliveries = PolledDelivery.find(:all, :conditions => {
      :recipient_email => user.email , 
      :is_delivered => false 
    }, :order => "notification_raised_time ASC")
    
    if pending_deliveries.count > 0 
      if Rails.env.production?
        NewsletterMailer.delay.polled_delivery( user.email, pending_deliveries )
      elsif Rails.env.development?
        NewsletterMailer.polled_delivery( user.email, pending_deliveries ).deliver
      end
    end
     
  end
  
  
  def corresponding_user_activity
    UserActivity.find(:first, :conditions => {
      :id => self.user_activity_id 
    })
  end
end
