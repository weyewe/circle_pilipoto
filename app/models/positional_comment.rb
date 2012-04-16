class PositionalComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :picture
  
  def self.create_with_comment( params, user, picture)
    @root_comment = Comment.build_from(picture, user.id, params[:comment_value])
    @root_comment.save
    
    @root_comment.create_comment_position( params[:x1], params[:y1], params[:x2], params[:y2] ,  picture)
  end
  
  def self.new_user_activity_for_new_comment( event_type, commenter, subject, secondary_subject )
    UserActivity.create_new_entry(event_type , 
                        commenter , 
                        subject , 
                        secondary_subject  )
  end
  
  
  
  
end
