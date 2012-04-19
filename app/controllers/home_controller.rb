class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:homepage, :article_list ]
  
  def dashboard
    if current_user.has_role?( :company_admin)
      redirect_to select_project_to_be_managed_url 
      return 
    end
    
    if current_user.has_role?(:employee) or current_user.has_role?(:client)
      redirect_to select_project_for_collaboration_url  
      return
    end
    
    # if current_user.has_role?(:student)
    #     redirect_to project_submissions_url 
    #     return
    #   end
  end
  
  
  def homepage
    render :layout => 'layouts/front_page'
  end
  
  def article_list
    render :layout => 'layouts/front_page'
    
  end
  
  
  
end
