class Company < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  
  has_many :projects
  has_many :articles
end
