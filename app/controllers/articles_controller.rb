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
    @article = nil
    if @project.nil? or (  not @project.created_by?(current_user) )
      redirect_to root_url 
      return 
    else
      @article = @project.create_article
    end
  end
  
=begin
  Article Content Edit
=end
  def edit_article_content
    @article = Article.find_by_id params[:article_id]
    @project = @article.project
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
    set_breadcrumb_for @article, 'edit_article_content_path' + "(#{@article.id})", 
          "Edit Content"
  end
  
  def update_article_content
    @article = Article.find_by_id params[:article_id]
    @article.update_attributes( params[:article] )
    
    redirect_to edit_article_content_url(@article, :notice => "This is awesome")
  end
  
=begin
  Article Image Ordering
=end

  def edit_image_ordering
    @article = Article.find_by_id params[:article_id]
    @article_pictures = @article.ordered_article_pictures 
    
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
    set_breadcrumb_for @article, 'edit_image_ordering_path' + "(#{@article.id})", 
          "Edit Image Ordering"
  end
  
  def update_image_ordering
    redirect_to edit_image_ordering_url( params[:article_id] )
  end
  
end
