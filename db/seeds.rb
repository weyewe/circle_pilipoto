=begin
  Seeds for the article
=end

WORK_CATEGORY.each do |category|
  ArticleCategory.create :name => category
end


=begin
  Setting up the roles.
  
  There are 2 roles associated with this app: company-wide role
  and the project role 
=end




company_admin_role  = Role.create( :name => ROLE_MAP[:company_admin] )
standard_role  = Role.create(:name => ROLE_MAP[:standard] )
# company_client_role  = Role.create(:name => ROLE_MAP[:client])

project_owner_role = ProjectRole.create(:name => PROJECT_ROLE_MAP[:owner])
project_collaborator_role = ProjectRole.create(:name => PROJECT_ROLE_MAP[:collaborator])
project_client_role = ProjectRole.create(:name => PROJECT_ROLE_MAP[:client])
      
puts "Done with creating company-roles and project-roles"
      
=begin
  Start creating the key-entities:
  1. company
  2. Company Admin, employee, and clients 
=end
# create the company 
circle_company = Company.create :name => "Demo Pilipoto"

#create the company admin user 
company_admin = User.create :email => "company_admin@pilipoto.com",
              :password => "company_admin",
              :password_confirmation => "company_admin"

company_admin.roles << company_admin_role
company_admin.save 

special_user = User.create :email => "rajakuraemas@gmail.com",
              :password => "willy1234",
              :password_confirmation => "willy1234"

special_user.roles << company_admin_role
special_user.save

# User.create_company_admin

employee_1 = User.create :email => "employee_1@gmail.com",
              :password => "employee_1",
              :password_confirmation => "employee_1"

employee_1.roles << standard_role
employee_1.save

employee_2 = User.create :email => "employee_2@gmail.com",
              :password => "employee_2",
              :password_confirmation => "employee_2"

employee_2.roles << standard_role
employee_2.save


client_1 = User.create :email => "client_1@gmail.com",
              :password => "client_1",
              :password_confirmation => "client_1"

client_1.roles << standard_role
client_1.save

              
client_2 = User.create :email => "client_2@gmail.com",
              :password => "client_2",
              :password_confirmation => "client_2"

client_2.roles << standard_role
client_2.save 

puts "Done with creating user entities"

#enrolling the users to the company

# circle_company.users << client_1
# circle_company.users << client_2
# 
# circle_company.users << employee_1
circle_company.users << special_user
circle_company.users << company_admin
circle_company.save

puts "Done with enrollment"

=begin
  Company has many project to begin with. 
  
=end


              
project_hash = {:title => "First Project", 
                :description => "The first ever project to describe that this shit is working. And you agree with it ",
                :picture_select_quota => 8 } 
                
project_1 = Project.create_with_user_company( project_hash , company_admin )

=begin
  After the project is created, owner will upload the feed pictures. For the user to select and comment. 
=end

=begin
  Project owner can't work alone. Hence, he has to invite more people -> collaborator and client
  The logic in User#invite_collaborator is that => it will look for the given email in the DB. 
      If it is found, will only be assigned project membership with the appropriate project_role 
        If it is not found, a new user will be created, email will be sent, and project_membership will be created
=end

# by using :client, the invited collaborator can only give comment/feedback
# and select the images they want to be used 
client_email = "client_demo@pilipoto.com"
# collaborator_email = "employee_1@gmail.com"
project_1.invite_project_collaborator( project_client_role, client_email) 
# :client_service can't communicate directly to the client. He can only do what the client asked
# project_1.invite_project_collaborator( project_collaborator_role , collaborator_email  )
=begin
  After confirming the invitation, the client will select the images he like. 
  Then, he will proceed in clicking the button "FINALIZE"
=end





