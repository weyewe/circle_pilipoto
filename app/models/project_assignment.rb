class ProjectAssignment < ActiveRecord::Base
  belongs_to :project_membership  
  belongs_to :project_role
end
