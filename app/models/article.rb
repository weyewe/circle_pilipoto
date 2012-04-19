class Article < ActiveRecord::Base
  belongs_to :project
  has_many :article_pictures 
  
  belongs_to :article_category 
  
  before_destroy :clear_article_pictures
  
  belongs_to :company
  belongs_to :user 
  
  
  
  def ordered_article_pictures
    ArticlePicture.find(:all, :conditions => {
      :article_id => self.id
    }, :order => "article_display_order ASC, created_at ASC")
    
    
  end
  
  
  def extract_image_ordering( params ) 
    self.article_pictures.each do |pic|
      name = "article_picture_#{pic.id}"
      if params[name.to_sym].nil?
        next
      else
        pic.article_display_order = params[name.to_sym].to_i
        pic.save
      end
      
    end
  end
  
  def has_content?
    ( not self.title.nil?   and not self.title.length == 0 ) or 
    (not self.description.nil? and not self.description.length == 0 ) or 
    (not self.teaser.nil? and not self.teaser.length == 0 )
  end
  
  def any_article_pictures_shown?
    self.article_pictures.where{
      (article_display_order.gt 0)
    }.count > 0 
  end
  
  
  def total_article_pictures_shown
    self.article_pictures.where{
      (article_display_order.gt 0)
    }.count 
  end
  
  
  def set_published
    self.is_displayed = true
    self.save
  end
  
  def set_unpublished
    self.is_displayed = false
    self.save
  end
  
  def publication_datetime_localtime 
    #for now, Jakarta by default. They can pick it later 
    if self.publication_datetime.nil?
      return nil
    else
      self.publication_datetime.in_time_zone("Jakarta")
    end
    
  end
  
  def set_publication_datetime( publication_datetime_utc )
    self.publication_datetime = publication_datetime_utc
    self.is_displayed = true
    self.save  
  end
  
=begin
  For the front page picture
=end

  def front_page_article_picture
    self.article_pictures.where(
      :is_selected_front_page => true 
    ).first
  end
  
  def total_front_page_candidates
    self.article_pictures.where{
      ( front_page_width.not_eq nil ) & (front_page_height.not_eq nil) & 
      ( front_page_width.eq FRONT_PAGE_IMAGE_WIDTH )  & 
      ( front_page_height.eq FRONT_PAGE_IMAGE_HEIGHT)
    }.count
  end
  
  def front_page_candidates
    self.article_pictures.where{
      ( front_page_width.not_eq nil ) & (front_page_height.not_eq nil) & 
      ( front_page_width.eq FRONT_PAGE_IMAGE_WIDTH )  & 
      ( front_page_height.eq FRONT_PAGE_IMAGE_HEIGHT)
    }
  end
  
=begin
  Creating Independent Article
=end

  def self.create_article_with_user_company(article_hash, current_user)
    if not current_user.has_role?(:company_admin)
      return false
    end
    
    company = current_user.company_under_perspective
    article = Article.create article_hash 
    
    article.user_id = current_user.id
    article.company_id = company.id
    article.article_type = ARTICLE_TYPE[:independent_article]
    article.save 
    
    return article
  end
  
  protected
  def clear_article_pictures
    self.article_pictures.each do |x|
      if Rails.env.production?
        x.is_deleted = true 
        x.save
      elsif Rails.env.development?
        x.destroy
      end
      
    end
    # once in a T hour, will do the deletion to s3 , background job
  end
end
