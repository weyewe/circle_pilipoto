class ProjectRole < ActiveRecord::Base
  has_many :project_assignments
  has_many :projects, :through => :project_assignments
  
  
end
