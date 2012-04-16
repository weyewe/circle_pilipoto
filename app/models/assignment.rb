class Assignment < ActiveRecord::Base
  belongs_to :user  # << move to the enrollment model
  # belongs_to :enrollment
  belongs_to :role
end
