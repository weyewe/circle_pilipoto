class ArticlePicturesController < ApplicationController
  
  def new
    @article = Article.find_by_id params[:article_id]
    @new_article_picture = @article.article_pictures.new 
    @front_page_candidates = @article.front_page_candidates
    
    add_breadcrumb "Select  article", 'select_article_to_upload_for_front_page_image_path'
    set_breadcrumb_for @article, 'new_article_article_picture_path' + "(#{@article.id})", 
            "Select or Upload Front Page"
  end
  
  def create
    @article = Article.find_by_id params[:article_id]
    new_article_picture = ''
    if not params[:transloadit].nil?
      new_picture = ArticlePicture.extract_uploads( 
        params[:transloadit][:results][":original".to_sym],
        params[:transloadit][:results][:resize_index], 
        params[:transloadit][:results][:resize_front_page], 
        params[:transloadit][:results][:resize_article], 
        params, params[:transloadit][:uploads] )
    end
    
    redirect_to new_article_article_picture_url(@article) 
  end
  
  
  def execute_select_front_page
    @article = Article.find_by_id( params[:membership_provider])
    @article_picture = ArticlePicture.find_by_id( params[:membership_consumer])
    
    if not params[:membership_decision].nil?
      if params[:membership_decision].to_i == TRUE_CHECK
        @article_picture.set_as_front_page
      elsif params[:membership_decision].to_i == FALSE_CHECK
        @article_picture.remove_from_front_page
      end
      
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url } 
      format.js
    end
  end
  

  
  
end

