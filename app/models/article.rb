class Article < ActiveRecord::Base
  belongs_to :project
  has_many :article_pictures 
  
  belongs_to :article_category 
  
  before_destroy :clear_article_pictures
  
  
  
  
  def ordered_article_pictures
    ArticlePicture.find(:all, :conditions => {
      :article_id => self.id
    }, :order => "article_display_order ASC, created_at ASC")
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
