class HomeController < ApplicationController
  
  # skip_before_filter :authenticate_user!, :only => [:homepage, :article_list ]
  skip_filter :authenticate_user!, :only => [ :raise_exception]
  
  def raise_exception  
    puts 'I am before the raise.'  
    raise 'An error has occured'  
    puts 'I am after the raise'  
  end
  
  
  def dashboard
    redirect_to select_project_for_collaboration_url
    return 
    # if current_user.has_role?( :company_admin)
    #   redirect_to select_project_to_be_managed_url 
    #   return 
    # end
    # 
    # if current_user.has_role?(:standard)
    #   redirect_to select_project_for_collaboration_url  
    #   return
    # end
    
  end
  
  
  def homepage
    # render :layout => 'layouts/front_page'
    
    redirect_to select_project_for_collaboration_url
  end
  
  def article_list
    render :layout => 'layouts/front_page'
    
  end
  
  
  
end
