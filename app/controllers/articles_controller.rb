class ArticlesController < ApplicationController
  
  def select_project_to_create_article
  end
  
  def publish_independent_article
  end
  
  def create_article_from_project
    
    if not current_user.has_role?(:premium)
      redirect_to root_url
      return
    end

    @project = Project.find_by_id( params[:entry_id])

    if @project.nil? or not @project.created_by?(current_user)
      redirect_to root_url 
      return 
    else
      @article = @project.create_article
    end
  end
end
