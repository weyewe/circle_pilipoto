class ProjectsController < ApplicationController
  def new 
    
    prevent_non_company_admin_to_view
    
    @project = Project.new
    @projects = current_user.projects 
    
  end
  
  def create
    prevent_non_company_admin_to_view
    
    # @project = Project.new( params[:project] )
    
    
    # if @project.save
    if @project = Project.create_with_user_company( params[:project], current_user )
      # @project.add_owner( current_user )
      redirect_to new_project_url(:notice => "Project #{@project.title} is succesfuly created.")
    end
  end
  
  
  def select_project_to_be_edited
    prevent_non_company_admin_to_view
    
    @projects = current_user.created_non_finalized_projects
    
    add_breadcrumb "Select  project", 'select_project_to_be_edited_path'
  end
  
  
  def edit
    @project = Project.find_by_id params[:id]

    ensure_project_membership_and_company_admin
    
    
    add_breadcrumb "Select  project", 'select_project_to_be_edited_path'
    set_breadcrumb_for @project, 'edit_project_path' + "(#{@project.id})", 
          "Edit Project #{@project.title}"
  end
  
  def update
    @project = Project.find_by_id params[:id]
    ensure_project_membership_and_company_admin_and_project_owner
    
    @project.update_attributes( params[:project] )
    
    redirect_to edit_project_url( @project, :notice => "Project is edited successfully")
    
  end
  
  
=begin
  TO invite member 
=end

  def select_project_to_invite_member
    prevent_non_company_admin_to_view
    
    @projects = current_user.created_non_finalized_projects 
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
  end
  
  def invite_member_for_project
    
    @project = Project.find_by_id( params[:project_id])
    
    ensure_project_membership_and_company_admin
    
    @new_user = User.new 
    
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
    set_breadcrumb_for @project, 'invite_member_for_project_path' + "(#{@project.id})", 
          "Invite member for #{@project.title}"
  end
  
  def execute_project_invitation
    
    @project = Project.find_by_id( params[:project_id] )
    
    ensure_project_membership_and_company_admin_and_project_owner
    
    project_role = ProjectRole.find_by_name(params[:role_name])
    
    if params[:user][:email].nil?  or params[:role_name].nil? or project_role.nil? 
      redirect_to invite_member_for_project_url(@project)
      return
    end
    
    @new_user = @project.invite_project_collaborator( project_role , params[:user][:email])
    # send email notification for the creation + for the role 
    # if it is new user, send the password  + project invitation
    # if it is old user, send the project invitation 
    # solve this 
    
    # if  @new_user.valid?
      redirect_to  invite_member_for_project_url(@project)
    # end
    # give different error messages according to the shite
    
    add_breadcrumb "Select project", 'select_project_to_invite_member_path'
    set_breadcrumb_for @project, 'invite_member_for_project_path' + "(#{@project.id})", 
          "Invite member for #{@project.title}"
    
    
  end
  
=begin
  To remove member 
=end

  def select_project_to_remove_member
    prevent_non_company_admin_to_view
    
    @projects = current_user.projects 
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
  end
  
  def remove_member_for_project
    @project = Project.find_by_id( params[:project_id])
    ensure_project_membership_and_company_admin
    
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
    set_breadcrumb_for @project, 'invite_member_for_project_path' + "(#{@project.id})", 
          "Invite member for #{@project.title}"
  end
  
  def execute_member_removal
    # javascript ajax ? 
    @project = Project.find_by_id( params[:project_id] )
    ensure_project_membership_and_company_admin
    
    if params[:user][:email].nil?  or params[:role_option].nil?
      redirect_to invite_member_for_project_url(@project)
      return
    end
    
    @new_user = @project.invite_project_collaborator(params[:role_option].to_sym, params[:user][:email])
    
    if  @new_user.valid?
      redirect_to  invite_member_for_project_url(@project)
    end
    
    add_breadcrumb "Select project", 'select_project_to_invite_member_path'
    set_breadcrumb_for @project, 'invite_member_for_project_path' + "(#{@project.id})", 
          "Invite member for #{@project.title}"
  end
  
=begin
  ACTIVE PROJECTS
=end
  def select_project_to_be_managed
    prevent_non_company_admin_to_view
    
    @projects = current_user.created_non_finalized_projects
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
  end
  
=begin
  For client
=end
  def execute_project_selection_done
    
    @project = Project.find_by_id( params[:project_id] )
    ensure_project_membership
    #  reject if current_uses's project role is not client 
    @project.set_done_with_pic_selection( current_user ) 
    
    respond_to do |format|
      format.html {  redirect_to root_url } 
      format.js
    end
  end

=begin
  FINALIZATION
=end

  def finalize_project
    @project = Project.find_by_id( params[:entry_id])
    ensure_project_membership_and_company_admin_and_project_owner
    

    if @project.nil? or not @project.created_by?(current_user)
      puts "This is the shit\n"*10
      redirect_to root_url 
      return 
    else
      puts "The cute thing\n"*10
      @project.finalize
    end
  end
  
  
  
  def select_project_to_be_de_finalized
    prevent_non_company_admin_to_view
    
    @projects = current_user.created_finalized_projects
    add_breadcrumb "Select  project", 'select_project_to_invite_member_path'
  end
  
  
  def de_finalize_project
    @project = Project.find_by_id( params[:entry_id])
    ensure_project_membership_and_company_admin

    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    else
      @project.de_finalize
    end
  end
      
=begin
  COllaboration
=end

  def select_project_for_collaboration
    # List all project where the curret user has project_membership 
    @projects = current_user.get_all_enlisted_project
    
  end
      
=begin
  PAGE MANAGEMENT : MARKETING 
=end

  def select_project_to_create_article
    @projects = current_user.finalized_projects
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
  end



end
