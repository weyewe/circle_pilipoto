class Company < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  
  has_many :projects
  has_many :articles
  
  def create_company_admin(email, password)
    #  enrollment? 
    # create users
    
    #  company admin can't be enrolled in 2 companies 
    
    # actually, it is not a problem
    # in the project creation, they can select the company 
    
    admin = User.create_company_admin(email, password)
    if not admin.nil?  and not self.has_enrolled?(admin) 
      self.users << admin 
      self.save 
      
      admin_role = ProjectRole.find_by_name PROJECT_ROLE_MAP[:owner]
      self.projects.where(:is_finalized => false ).each do |project|
        project.add_project_membership( admin_role, admin )
      end
      
      return admin
    end
    
    admin_role = ProjectRole.find_by_name PROJECT_ROLE_MAP[:owner]
    self.projects.where(:is_finalized => false ).each do |project|
      project.add_project_membership( admin_role, admin )
    end
    
    
    return admin 
  end
  
  
  def has_enrolled?(user)
    Enrollment.find(:all, :conditions => {
      :user_id => user.id, 
      :company_id => self.id ,
      :is_active => true 
    }).count > 0 
  end
  
  
  def company_admins
    array = []
    self.users.collect do |x| 
      if x.has_role?(:company_admin)
        array << x
      end
    end
    return array
  end
  
end
