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
 
 has_one :article
 
 belongs_to :company
 
 
=begin
  Project Creation
=end
# self.create_with_user_company( project_hash , current_user, company )
  def self.create_with_user_company( project_hash , current_user )
    if not current_user.has_role?(:company_admin)
      return false
    end
    
    company = current_user.company_under_perspective
    project = Project.create project_hash 
    
    project.set_company( company )
    project.add_owner( current_user )
    
    return project 
  end
  
  def set_company( company)
    self.company_id = company.id
    self.save 
  end
   
  
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
    owner_project_role = ProjectRole.find_by_name( PROJECT_ROLE_MAP[:owner])
    owner_membership.add_roles([owner_project_role])
  end
  
  def members
    users_id_list = self.project_memberships.map{|x| x.user_id}
    User.find(:all, :conditions => {
      :id => users_id_list 
    })
  end
  
  
  def invite_project_collaborator( project_role, email )
    # How can we edit the role? 
    # later. now , ensure that we can send the email 
    
    # project_owner ?
    company = self.company
    # sending the pilipoto registration over here
    project_collaborator = User.find_or_create_and_confirm(email , self )
    
    
    
    if project_collaborator == self.project_owner
      return project_collaborator
    end
    
    if not project_collaborator.valid?
      return project_collaborator 
    else
      # sending the project role  assignment over here
      self.add_project_membership( project_role, project_collaborator )
      if not company.has_enrolled?(project_collaborator)
        company.users << project_collaborator
        company.save
      end
      return project_collaborator
    end
    
  end
  
  
  def add_project_membership( project_role, project_collaborator )
    
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
                
    project_membership.add_roles( [project_role] )
    Project.delay.deliver_add_role_notification( self, project_role, project_collaborator)
  end
  
  def Project.deliver_add_role_notification( project, project_role, project_collaborator)
    NewsletterMailer.notify_new_role_assignment( project, project_role, project_collaborator ).deliver
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
     ).count
  end
  
  def selected_and_approved_original_pictures
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
    
    (self.selected_original_pictures_count == self.approved_selected_files_count) and 
    ( self.selected_original_pictures_count > 0 )
  end
  
  
  def created_by?(user)
    self.owner_id == user.id 
  end
  
  def owner
    User.find_by_id self.owner_id 
  end
  
  def finalize
    self.is_finalized = true 
    self.save 
    
    article = self.article
    if not article.nil?
      article.is_displayed = true 
      article.save
    end
    
    return self 
    
  end
  
  def de_finalize
    self.is_finalized = false 
    self.save 
    
    article = self.article
    if not article.nil?
      article.is_displayed = false
      article.save 
    end
  end
  
  
  def approved_selected_files
    self.original_pictures.where{
          ( approved_revision_id.not_eq  nil)  & 
          ( is_deleted.eq false)
      }.map{|x| x.last_revision }
  end
  
  
  def approved_selected_files_count
    self.original_pictures.where{
          ( approved_revision_id.not_eq  nil)  & 
          ( is_deleted.eq false)
      }.count
  end
  
  def revisions_count
    self.pictures.where(:is_original => false, :is_deleted => false ).count
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
  
  def set_done_with_pic_selection(user)
    # if user.project_role != client_role 
    #   return nil
    # end
    
    if not user.has_project_role?( :client, self)
      return nil 
    end
    
    self.done_with_selection  = true 
    self.save 
    
    # UserActivity.create_new_entry(
    #       EVENT_TYPE[:done_with_picture_selection],
    #       user,  # actor 
    #       self ,  # subject 
    #       nil ,  # secondary subjet
    #       self  # the project 
    # )
    
    #  send the email, listing all the images selected
    Project.delay.send_done_selection_notification( self ) 
  end
  
  def Project.send_done_selection_notification( project) 
    NewsletterMailer.send_done_selection_notification(project).deliver
  end
  
  def cancel_done_with_pic_selection
    self.done_with_selection  = false 
    self.save 
  end
  
  def is_picture_selection_done?
    self.done_with_selection == true 
  end
  
  
  
  
  def Project.send_ready_to_be_finalized_email( project) 
    NewsletterMailer.send_ready_to_be_finalized_notification(project).deliver
    # NewsletterMailer.notify_reset_login_info( new_user, new_password ).deliver
  end
  
=begin
  integration with article
=end

  def create_article(current_user ) 
    if self.has_article?
      self.article
    else
      article = Article.create :project_id => self.id , 
                      :company_id => self.company_id , 
                      :user_id => current_user.id ,
                      :article_type => ARTICLE_TYPE[:mapped_from_project]
      # wrong wrong
      #it should be the last approved pic
      self.selected_original_pictures.each do |pic|
        last_revision = pic.last_revision
        article.article_pictures.create(
          :name                       => last_revision.name                        , 
          :original_image_size        => last_revision.original_image_size         ,
          :original_image_url         => last_revision.original_image_url          ,           
          :index_image_url            => last_revision.index_image_url              ,
          :index_image_size           => last_revision.index_image_size             ,
                                         
          :article_image_size         => last_revision.article_image_size           ,
          :article_image_url          => last_revision.article_image_url            ,
    # to check the front_page url and size : we observe the original pic
          :width                      => last_revision.width                       ,
          :height                     => last_revision.height                     
        )
      end
      
      return article
    end
  end
  
  
  def has_article?
    not self.article.nil?
  end
  
  
end
