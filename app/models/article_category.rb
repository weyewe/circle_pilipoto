class ArticleCategory < ActiveRecord::Base
  has_many :articles
end
