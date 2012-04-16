=begin
  Initially, there is nothing. 
  So, we create the first user that happens to be an owner 
=end
premium_user = User.create :email => "premium@gmail.com",
              :password => "willy1234",
              :password_confirmation => "willy1234"
              
owner_role  = Role.create( :name => "Premium")
standard_role  = Role.create(:name => "Standard")

project_owner_role = ProjectRole.create(:name => "Owner")
project_collaborator_role = ProjectRole.create(:name => "Collaborator")
project_client_role = ProjectRole.create(:name => "Client")
      
# we give the owner a premium status         
premium_user.add_roles([:premium])

=begin
  Then, we shall proceeed by creating first project .
  Of course, only owner that can create project 
=end
              
first_project = Project.new :title => "First Project", 
                :description => "The first ever project to describe that this shit is working. And you agree with it ",
                :picture_select_quota => 8
                

first_project.save 

first_project.add_owner(premium_user )

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
client_email = "client@gmail.com"
collaborator_email = "collaborator@gmail.com"
first_project.invite_project_collaborator(:client, client_email) 
# :client_service can't communicate directly to the client. He can only do what the client asked
first_project.invite_project_collaborator(:collaborator, collaborator_email  )
=begin
  After confirming the invitation, the client will select the images he like. 
  Then, he will proceed in clicking the button "FINALIZE"
=end





