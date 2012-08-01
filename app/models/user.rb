class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  
  # Models  => Role locking is based on user
  has_many :assignments
  has_many :roles, :through => :assignments
  
  # project membership
  has_many :project_memberships 
  has_many :projects, :through => :project_memberships 
  
  #enrollment to the company
  has_many :companies, :through => :enrollments
  has_many :enrollments
  
  # has_many :pictures
  after_create :send_confirmation_email 
  
  has_many :articles 

  
  
=begin
  all users, manage company
=end  

  def company_under_perspective
    self.enrollments.find(:first, :conditions => {
      :is_current_perspective => true 
      }).company 
  end

=begin
  Inviting collaborator to the project 
  User.create_and_confirm_and_send_project_invitation( email, project_role_sym, project ) 
=end
  def User.create_company_admin(email, password)
    
    
    if password.nil?
      password = UUIDTools::UUID.timestamp_create.to_s[0..7]
    end
    
    company_admin = User.find_by_email(email)
    
    if company_admin.nil?
      company_admin = User.create(:email => email, :password => password, :password_confirmation => password)
      if not company_admin.nil?
        User.delay.send_new_registration_notification( company_admin , password )
      end
      # send email notification 
    end
    
    if not company_admin.has_role?(:company_admin)
      company_admin_role = Role.find_by_name(  ROLE_MAP[:company_admin] )

      company_admin.roles << company_admin_role
      company_admin.save
      
      User.delay.send_company_admin_approval_notification( company_admin   )
      return company_admin
    end
    
    return company_admin
  end
  
  
  def reset_password_pilipoto
    password = UUIDTools::UUID.timestamp_create.to_s[0..7]
    self.password =password
    self.password_confirmation = password
    self.save 
    NewsletterMailer.notify_new_user_registration(self, password).deliver
  end
  
  def User.send_company_admin_approval_notification( company_admin)
    NewsletterMailer.send_company_admin_approval_notification( company_admin ).deliver
  end

  def User.create_and_confirm( email , project  ) 
    new_user = User.new  :email => email 
    temporary_password =  UUIDTools::UUID.timestamp_create.to_s[0..7]
    
    new_user.password = temporary_password
    new_user.password_confirmation = temporary_password
    new_user.save 
    
    standard_role = Role.find_by_name(ROLE_MAP[:standard])
    new_user.roles << standard_role
    new_user.save 
    

    User.delay.send_new_registration_notification( new_user , temporary_password )  
    return new_user 
  end
  
  def User.send_new_registration_notification( new_user, new_password )
    NewsletterMailer.notify_new_user_registration( new_user, new_password).deliver
  end


  def send_confirmation_email
    puts "Hey ya baby, we have created the new user. Please log in"
  end
  
  def change_email_admin( new_email )
    password  = UUIDTools::UUID.timestamp_create.to_s[0..7]
    self.email = new_email
    self.password = password
    self.password_confirmation = password
    self.save
    
    
    User.delay.send_reset_login_info( self, password  )
  end
  
  def reset_password
    password  = UUIDTools::UUID.timestamp_create.to_s[0..7]
    self.password = password
    self.password_confirmation = password
    self.save
    User.delay.send_reset_login_info( self, password  )
  end
  
  def User.send_reset_login_info( new_user, new_password )
    NewsletterMailer.notify_reset_login_info( new_user, new_password ).deliver
  end
  
  
=begin
  Project Role
=end
  def has_project_role?( project_role_sym, project)
    if project.nil?
      puts "project id is nil"
      return false
    end
    project_membership = ProjectMembership.find(:first, :conditions => {
      :project_id => project.id, 
      :user_id => self.id 
    })
    
    if project_membership.nil?
      puts "project membership is nil"
      return false 
    end
    project_membership.has_project_role?(project_role_sym)
  end


=begin
  Role assignment related 
=end
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def add_roles( role_symbol_array )
    role_symbol_array.each do |role_sym|
      add_role_if_not_exist( Role.find_by_name( ROLE_MAP[role_sym] ).id )
    end
  end
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  def add_role_if_not_exist(role_id)
    result = Assignment.find(:all, :conditions => {
      :user_id => self.id,
      :role_id => role_id
    })
    
    if result.size == 0 
      Assignment.create :user_id => self.id, :role_id => role_id
    end
  end
  
  
  def feed_standard_roles
    self.add_roles( [:uploader, :voter])
  end
  
  def album_for_project( project  )
    Album.find(:first, :conditions => {
      :user_id => self.id ,
      :project_id => project.id
    })
  end
  
=begin
  Related with project 
=end
  
  def User.find_or_create_and_confirm(email , project )
    user =  User.find_by_email email 
    
    #  if there is user, check the role as well
    
    
    
    if user.nil? 
      return User.create_and_confirm( email, project) 
    else
      return user
    end
  end
  
  def project_membership_for_project(project)
    ProjectMembership.find(:first, :conditions => {
      :project_id => project.id,
      :user_id => self.id
    })
  end
  
  
  def get_all_enlisted_project
    # Project.all
    # projects = ProjectMembership.includes(:project).find(:all, :conditions => {
    #         :user_id => self.id ,
    #         :project => {:is_deleted => false}
    #       }, :order => "created_at DESC").map{ |x| x.project }
    #       
    user = self
    projects=  Project.joins(:project_memberships).where(:is_deleted => false, 
            :project_memberships => {:user_id => user.id }).order("created_at DESC")
  end
  
  
=begin
  Premium User 
=end
  # this has to change.. using the role of company_admin
  def finalized_projects
    self.projects.where( :is_finalized => true )
  end
  
  def non_finalized_projects
    self.projects.where( :is_finalized => false )
  end
  
  def created_non_finalized_projects
    # self.company.projects.where(:is_finalized => false )
    # find the company where he is the company_admin 
    project_list = [] 
    self.projects.where(:is_finalized => false, :is_deleted => false ).order('created_at DESC').each do |x|
      if self.has_project_role?(:owner, x)
        project_list << x
      end
    end
    return project_list
  end
  
  def created_finalized_projects
    project_list = [] 
    self.projects.where(:is_finalized => true).each do |x|
      if self.has_project_role?(:owner, x)
        project_list << x
      end
    end
    return project_list
  end
  
=begin
  Special User : those who can add / promote a user to have company_admin role 
=end
  def is_special_user?
    SPECIAL_LOGIN.include?(self.email)
  end
  
  
  
=begin
  All about timezone
=end
  def set_time_zone( offset_timezone)
    offset = offset_timezone.split("_")[0]
    time_zone = offset_timezone.split("_")[1]
    self.time_zone = time_zone
    self.utc_offset= offset.to_i
    self.save
  end
  
  def get_time_zone
    if self.time_zone.nil?  ||self.time_zone.length == 0 
      return "UTC"
    end
    
    self.time_zone 
  end
  
  def get_utc_offset
    if self.utc_offset.nil?
      return 0
    end
    
    return self.utc_offset 
  end
  
=begin
  delivery hours 
=end

  def array_of_scheduled_delivery_hours
    self.scheduled_delivery_hours.split(",").map {|x| x.to_i }
  end

  def set_delivery_method( selected_delivery_method, delivery_hours)
    # the delivery hour is specified at the user's time zone.. we need to convert it to UTC
    if selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:instant]
      self.delivery_method = NOTIFICATION_DELIVERY_METHOD[:instant]
      self.scheduled_delivery_hours = '' 
      self.save 
      # we must clear all the PolledDelivery
      PolledDelivery.delay.clear_all_pending_delivery( self )

      return 
    elsif selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:scheduled] && 
        delivery_hours.length != 0  #yeah, he uploaded the schedule 
      self.delivery_method = NOTIFICATION_DELIVERY_METHOD[:scheduled]
      self.scheduled_delivery_hours =  delivery_hours.map{ |x| ( x - self.get_utc_offset) %24 }.join(",")
      self.save 
      return
    else

    end
  end

  def delivery_hours_in_server_time
    self.scheduled_delivery_hours.split(",").map{|x| ( x.to_i )%24 }.sort
  end

  def delivery_hours_in_user_timezone
    # converting the delivery hours to user timezone
    self.scheduled_delivery_hours.split(",").map{|x| ( x.to_i + self.get_utc_offset )%24 }.sort

  end
  
end

