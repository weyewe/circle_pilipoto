class CompaniesController < ApplicationController
  
  before_filter :prevent_non_special_user
  def new 
    
    @company = Company.new
    @companies = Company.all 
  end
  
  
  def create
    
    
    if @company = Company.create( :name => params[:company][:name])
      # @project.add_owner( current_user )
      redirect_to new_company_url(:notice => "Company #{@company.name} is succesfuly created.")
    end
  end
  
  
  
  
  def select_company_to_be_edited
    
    
    
    @companies = Company.all
    
    add_breadcrumb "Select  company", 'select_company_to_be_edited_path'
  end
  
  def  edit
    
    
    @company = Company.find_by_id params[:id]
    add_breadcrumb "Select  project", 'select_company_to_be_edited_path'
    set_breadcrumb_for @company, 'edit_company_path' + "(#{@company.id})", 
          "Edit #{@company.name}"
  end
  
  def update
    
    # editable_fields = [:title, :description, :picture_select_quota]
    @company = Company.find_by_id params[:id]
    @company.update_attributes( params[:company] )
    
    redirect_to edit_company_url( @company, :notice => "Company is edited successfully")
  end
  
  
=begin
  Adding company admin
=end
  def select_company_to_create_admin
    
    
    @companies = Company.all
    
    add_breadcrumb "Select  company", 'select_company_to_create_admin_path'
  end
  
  def new_company_admin
    
    @company = Company.find_by_id params[:company_id]
    @new_user = User.new 
    @company_admins = @company.company_admins
    
    add_breadcrumb "Select  company", 'select_company_to_create_admin_path'
    set_breadcrumb_for @company, 'new_company_admin_path' + "(#{@company.id})", 
          "Enter Admin email"
  end
  
  def create_company_admin
    email = params[:user][:email]
    @company = Company.find_by_id(params[:company_id])
    result_company_admin = @company.create_company_admin( email, nil ) 
    
    if not result_company_admin.nil?
      redirect_to new_company_admin_url(@company, :notice => "We created the #{email} as company admin.")
    end
      
  end
  
  
  protected 
  def prevent_non_special_user
    if not current_user.is_special_user?
      redirect_to select_project_for_collaboration_url 
      return
    end
  end
  
  
  
end
