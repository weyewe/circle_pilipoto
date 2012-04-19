class Company < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
end
