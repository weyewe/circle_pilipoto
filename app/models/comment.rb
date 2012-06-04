class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  
  validates_presence_of :body
  validates_presence_of :user
  
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  
  # NOTE: Comments belong to a user
  belongs_to :user
  
  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id 
    c.commentable_type = obj.class.name 
    c.body = comment 
    c.user_id = user_id
    c
  end
  
  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0 
  end
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
  
  
  
=begin
  Additional for positional comments 
=end
  
  def create_comment_position( x_start, y_start, x_end, y_end , picture)
    comment_position = PositionalComment.create(:comment_id => self.id, 
      :x_start => x_start, 
      :y_start => y_start,
      :x_end => x_end,
      :y_end => y_end,
      :picture_id => picture.id
    )
    
    # self.delay.send_feedback_notification_email
    
    return comment_position
  end
  
  def commented_object 
    eval("#{self.commentable_type}.find(#{self.commentable_id})")
  end
  
  
  def self.new_user_activity_for_comment_reply( event_type, author, subject, secondary_subject, project )
    UserActivity.create_new_entry(event_type , 
                        author , 
                        subject , 
                        secondary_subject,
                        project   )
  end
  
  
  
end
