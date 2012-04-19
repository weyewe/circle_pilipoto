class Enrollment < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  
  after_create :set_current_as_the_active_perspective
  
  
  
  protected
  def set_current_as_the_active_perspective
    Enrollment.find(:all, :conditions => {
      :user_id => self.user_id 
    }).each do |enrollment|
      if enrollment.id == self.id 
        next
      else
        enrollment.is_current_perspective = false
        enrollment.save 
      end
      
    end
  end
end
