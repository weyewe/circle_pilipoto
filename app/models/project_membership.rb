class ProjectMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  has_many :project_assignments 
  has_many :project_roles, :through => :project_assignments 
  
  
  
  def ProjectMembership.find_for( user, project )
  end
  
  def has_role?(role_sym)
    project_roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  
  def has_project_role?(role_sym)
    has_role?(role_sym)
  end
  
  # def add_project_role( project_role_sym )
  #     self.add_roles( [project_role_sym] )
  #   end
  #   
  
  
  def add_roles( project_role_array )
    project_role_array.each do |project_role|
      add_role_if_not_exist(  project_role.id )
    end
  end
  
  
  
  def add_role_if_not_exist(role_id)
    result = ProjectAssignment.find(:all, :conditions => {
      :project_membership_id => self.id,
      :project_role_id => role_id
    })
    
    if result.size == 0 
      ProjectAssignment.create :project_membership_id => self.id, :project_role_id => role_id
    end
  end
  
  
  
end
