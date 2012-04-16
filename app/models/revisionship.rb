class Revisionship < ActiveRecord::Base
  belongs_to :picture
  belongs_to :revision, :class_name => "Picture"
end
