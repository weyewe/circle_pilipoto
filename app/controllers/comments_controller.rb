class CommentsController < ApplicationController
  def create_first_child_comment
    save_comment
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
    
  end
  
  def create_child_comment
    save_comment
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
    
    
  end
  
  protected
  def save_comment
    @root_comment = Comment.find_by_id(params[:root_comment_id])
    @picture = Picture.find_by_id( params[:picture_id])

    
    @comment = Comment.build_from( @picture, current_user.id, params[:comment][:body] )
    @comment.save
    @comment.move_to_child_of(@root_comment)

    Comment.new_user_activity_for_comment_reply(
      EVENT_TYPE[:reply_comment],
      current_user,
      @comment,
      @comment.commented_object,
      @picture.project 
    )
  end
end
