class Article < ActiveRecord::Base
  belongs_to :project
  has_many :article_pictures 
  
  belongs_to :article_category 
end
