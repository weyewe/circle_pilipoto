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
  
  # has_many :pictures
  after_create :send_confirmation_email 
  
  
=begin
  Inviting collaborator to the project 
  User.create_and_confirm_and_send_project_invitation( email, project_role_sym, project ) 
=end
  def User.create_and_confirm( email  ) 
    new_user = User.new  :email => email 
    temporary_password =  "willy1234" #UUIDTools::UUID.timestamp_create.to_s[0..7]
    
    new_user.password = temporary_password
    new_user.password_confirmation = temporary_password
    new_user.save 
    
    standard_role = Role.find_by_name("Standard")
    new_user.roles << standard_role
    new_user.save 
    
    return new_user 
    # return new_user 
    # send the project invitation mail 
    
  end


  def send_confirmation_email
    puts "Hey ya baby, we have created the new user. Please log in"
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
  
  def User.find_or_create_and_confirm( email )
    user =  User.find_by_email email 
    
    if user.nil? 
      return User.create_and_confirm( email) 
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
    ProjectMembership.includes(:project).find(:all, :conditions => {
      :user_id => self.id 
    }).map{ |x| x.project }
  end
  
  

  
  
end
