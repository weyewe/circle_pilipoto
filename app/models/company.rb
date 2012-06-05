class Company < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  
  has_many :projects
  has_many :articles
  
  def create_company_admin(email, password)
    #  enrollment? 
    # create users
    admin = User.create_company_admin(email, password)
    if not admin.nil?  and not self.has_enrolled?(admin)
      self.users << admin 
      self.save 
      return admin
    end
    
    return nil 
    
    
  end
  
  
  def has_enrolled?(user)
    Enrollment.find(:all, :conditions => {
      :user_id => user.id, 
      :company_id => self.id ,
      :is_active => true 
    }).count > 0 
  end
  
  
end
