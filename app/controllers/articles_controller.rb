class ArticlesController < ApplicationController
  
=begin
  Article Creation : from project and independent 
=end
  def create_article_from_project
    if not current_user.has_role?(:company_admin)
      redirect_to root_url
      return
    end

    @project = Project.find_by_id( params[:entry_id])
    @article = nil
    if @project.nil? or (  not @project.created_by?(current_user) )
      redirect_to root_url 
      return 
    else
      @article = @project.create_article( current_user )
    end
  end
  
  # the independent article 
  
  def new_independent_article
    @articles = current_user.
                    company_under_perspective.
                    articles.
                    where(:article_type => ARTICLE_TYPE[:independent_article]).
                    order("created_at DESC")
                    
                    
    @new_article = Article.new  
    
    add_breadcrumb "Create or Manage Independent Article", 'new_independent_article_path'
    
    
  end
  
  def create_independent_article
    
    # if @article.save 
    if @article = Article.create_article_with_user_company(params[:article] , current_user )
      redirect_to new_independent_article_url( :notice => "Success in creating article with title: <b>#{@article.title}</b>")
    else
      redirect_to new_independent_article_url( :error => "Fail to create article")
    end
    
  end
  
  
  def edit_independent_article_content
    edit_content_routine
    add_breadcrumb "Select  article", 'new_independent_article_path'
    set_breadcrumb_for @article, 'edit_independent_article_content_path' + "(#{@article.id})", 
          "Edit Content"
  end
  
  def edit_independent_article_image_ordering
    edit_image_ordering_routine
    
    add_breadcrumb "Select  project", 'new_independent_article_path'
    set_breadcrumb_for @article, 'edit_independent_article_image_ordering_path' + "(#{@article.id})", 
          "Edit Image Ordering"
  end
  
  def edit_independent_article_publication
    edit_publication_routine
    
    add_breadcrumb "Select  project", 'new_independent_article_path'
    set_breadcrumb_for @article, 'edit_independent_article_publication_path' + "(#{@article.id})", 
          "Edit Publication Date"
  end
  
  def update_independent_article_content
    update_content_routine
    
    redirect_to edit_independent_article_content_url(@article, :notice => "This is awesome")
  end
  
  def update_independent_article_image_ordering
    update_image_ordering_routine
    redirect_to edit_independent_article_image_ordering_url( params[:article_id], 
                  :notice => "Image Ordering is Successful!" )
  end
  
  def update_independent_article_publication
    update_publication_routine
    
    if not @publication_datetime.nil?
      @article.set_publication_datetime( @publication_datetime.getutc) 
      redirect_to edit_independent_article_publication_url(@article, :notice => "The publication date is updated successfully")
      return
    else
      redirect_to edit_independent_article_publication_url(@article, 
            :error => "The publication date <b>#{params[:article][:publication_datetime]}</b> is invalid")
      return 
    end
  end
  
  
=begin
  Article Content Edit
=end
  def edit_article_content
    edit_content_routine
    
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
    set_breadcrumb_for @article, 'edit_article_content_path' + "(#{@article.id})", 
          "Edit Content"
  end
  
  def update_article_content
    update_content_routine
    
    
    redirect_to edit_article_content_url(@article, :notice => "This is awesome")
  end
  
=begin
  Article Image Ordering
=end

  def edit_image_ordering
    
    edit_image_ordering_routine
    
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
    set_breadcrumb_for @article, 'edit_image_ordering_path' + "(#{@article.id})", 
          "Edit Image Ordering"
  end
  
  def update_image_ordering
    
    update_image_ordering_routine
    
    redirect_to edit_image_ordering_url( params[:article_id], :notice => "Image Ordering is Successful!" )
  end
  
=begin
  Publishing Article
=end

  def edit_publication
   
    edit_publication_routine
    
    add_breadcrumb "Select  project", 'select_project_to_create_article_path'
    set_breadcrumb_for @article, 'edit_publication_path' + "(#{@article.id})", 
          "Edit Publication Date"
  end
  
  def update_publication
    
    update_publication_routine
            
    if not @publication_datetime.nil?
      @article.set_publication_datetime( @publication_datetime.getutc) 
      redirect_to edit_publication_url(@article, :notice => "The publication date is updated successfully")
      return
    else
      redirect_to edit_publication_url(@article, 
            :error => "The publication date <b>#{params[:article][:publication_datetime]}</b> is invalid")
      return 
    end
  end
  
  
  def execute_publish_project_based_article
    @article = Article.find_by_id params[:entry_publish_id]
    @project= @article.project 
    
    publish_decision = params[:publisher_action].to_i
    
    if publish_decision == TRUE_CHECK
      @article.set_published
    elsif publish_decision == FALSE_CHECK
      @article.set_unpublished
    end
  end
  
=begin
  Front page Image
=end
  def select_article_to_upload_for_front_page_image 
    @articles = Article.all 
    
    add_breadcrumb "Select  article", 'select_project_to_create_article_path'
    # set_breadcrumb_for @article, 'edit_publication_path' + "(#{@article.id})", 
    #         "Edit Publication Date"
  end
  
  protected
  def edit_content_routine
    @article = Article.find_by_id params[:article_id]
    @project = @article.project
  end
  
  def edit_image_ordering_routine
    @article = Article.find_by_id params[:article_id]
    @article_pictures = @article.ordered_article_pictures
  end
  
  def edit_publication_routine
    @article = Article.find_by_id params[:article_id]
  end
  
  def update_content_routine
    @article = Article.find_by_id params[:article_id]
    @article.update_attributes( params[:article] )
  end
  
  def update_image_ordering_routine
    @article = Article.find_by_id params[:article_id]
    @article.extract_image_ordering( params )
  end
  
  def update_publication_routine
    @article = Article.find_by_id params[:article_id]
    @publication_datetime = extract_date_time( 
                  params[:article][:publication_datetime], 
                  '1' , 
                  '0', JAKARTA_HOUR_OFFSET )
  end
end
