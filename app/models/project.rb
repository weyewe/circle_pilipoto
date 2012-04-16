class Project < ActiveRecord::Base
  
  # Models  => Role locking is based on user
  # has_many :project_assignments
  #  has_many :project_roles, :through => :project_assignments 
  
  
  has_many :project_memberships 
  has_many :users, :through => :project_memberships 
  
  has_many :pictures 
  
  
 validates_numericality_of :picture_select_quota
 validates_presence_of :title, :picture_select_quota
 
 
 attr_accessible :title, :description, :picture_select_quota
   
  
  def members_with_project_role( role_sym_array )
    project_role_id_list= []
    
    role_sym_array.each do |role_sym|
      project_role = ProjectRole.find_by_name( PROJECT_ROLE_MAP[role_sym])
      project_role_id_list << project_role.id 
    end
    # project_role = ProjectRole.find_by_name( PROJECT_ROLE_MAP[role_sym])
    
    project_membership_id_list = self.project_memberships.select(:id).map {|x| x.id }
    
    
    ProjectAssignment.includes(:project_membership => :user).find(:all,:conditions => {
      :project_role_id => project_role_id_list , 
      :project_membership_id => project_membership_id_list
    })
  end
  
  def clients
    members_with_project_role( [:client] ).map{|x| x.project_membership.user}
  end
  
  def collaborators
    members_with_project_role( [:collaborator] ).map{|x| x.project_membership.user}
  end
  
  def members
    members_with_project_role( [:collaborator, :client] ).map{|x| x.project_membership.user}
  end
  
  
  
  
  def project_owner 
    User.find_by_id( self.owner_id )
  end
  
  
  
  def add_owner( user ) 
    self.owner_id = user.id
    self.save 
    
    owner_membership = ProjectMembership.create(:user_id => user.id, :project_id => self.id )
    owner_membership.add_roles([:owner])
  end
  
  def members
    users_id_list = self.project_memberships.map{|x| x.user_id}
    User.find(:all, :conditions => {
      :id => users_id_list 
    })
  end
  
  
  def invite_project_collaborator( project_role_sym, email )
    project_collaborator = User.find_or_create_and_confirm(email)
    
    if project_collaborator == self.project_owner
      return project_collaborator
    end
    
    if not project_collaborator.valid?
      puts "It is all nice and smooth over here\n"*5
      return project_collaborator 
    else
      puts "We are inside this shit add project membership\n"*10
      self.add_project_membership( project_role_sym, project_collaborator )
      return project_collaborator
    end
    
  end
  
  
  def add_project_membership( project_role_sym, project_collaborator )
    
    project_membership = ProjectMembership.find(:first, :conditions => {
      :user_id => project_collaborator.id ,
      :project_id => self.id
    })
    
    if project_membership.nil?
      project_membership = ProjectMembership.create(
                      :user_id => project_collaborator.id ,
                      :project_id => self.id 
                  )
    end
                
    project_membership.add_roles( [project_role_sym] )
  end
  
  def get_project_membership_for( user )
    self.project_memberships.where(:user_id => user.id).first
  end
  
=begin
  Picture management related
=end
  def nav_original_pictures( only_all_selected )
    if only_all_selected == true 
      self.pictures.where(:is_original => true, 
                          :is_selected => true  ).
                          order("created_at ASC")
    else
      self.pictures.where(:is_original => true ).order("created_at ASC")
    end
  end
  
  def nav_original_pictures_id( only_all_selected )
    self.nav_original_pictures(only_all_selected).select(:id).map do |x|
      x.id
    end
  end
  
  
  def selected_original_pictures_count
    self.pictures.where(:is_original => true, 
                        :is_deleted => false, 
                        :is_selected => true 
     ).count
  end
  
  def selected_original_pictures
    self.pictures.where(:is_original => true, 
                        :is_deleted => false, 
                        :is_selected => true 
     )
  end
  
  def selected_and_approved_original_pictures_count
    self.pictures.where(:is_original => true, 
                        :is_deleted => false, 
                        :is_selected => true ,
                        :is_approved => true 
     )
  end

  def ready_to_be_finalized?
    # total_selected_pictures = self.selected_original_pictures_count
    #   # for each count the approved state per each original picture
    #   total_approved_pictures= self.original_pictures.where{
    #         ( approved_revision_id.not_eq  nil)  & 
    #         ( is_deleted.not_eq false)
    #     }
    #   
    
    self.selected_original_pictures_count == self.approved_selected_files_count
  end
  
  def approved_selected_files_count
    self.original_pictures.where{
          ( approved_revision_id.not_eq  nil)  & 
          ( is_deleted.eq false)
      }.count
  end
  
  def revisions_count
    self.original_pictures.where{
          ( is_original.eq  false)  & 
          ( is_deleted.eq false)
      }.count
  end
  
=begin
  a = Project.last
  counter = a.original_pictures.where{(approved_revision_id.not_eq nil)}.count
=end

  def original_pictures
    self.pictures.where(:is_original => true ).order("created_at ASC")
  end
  

  

  def original_pictures_id
    self.pictures.where(:is_original => true ).order("created_at ASC").select(:id).map do |x|
      x.id
    end
  end
  
  def first_submission
    picture_submissions = self.original_pictures
    if picture_submissions.count == 0 
      return nil
    else
      return picture_submissions.first
    end
  end
  
  def selected_original_pictures
    self.original_pictures.includes(:revisions).where(:is_selected => true )
  end
  
  
  def can_select_more_pic?
    self.selected_original_pictures.count < self.picture_select_quota 
  end
  
  def set_done_with_pic_selection
    self.done_with_selection  = true 
    self.save 
  end
  
  def cancel_done_with_pic_selection
    self.done_with_selection  = false 
    self.save 
  end
  
  def is_picture_selection_done?
    self.done_with_selection == true 
  end
  
  
  
  
end
