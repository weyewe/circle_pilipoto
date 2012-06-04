class PositionalCommentsController < ApplicationController
  def create
    @picture = Picture.find_by_id( params[:picture_id] )
    # @project_submission = @picture.project_submission
    @positional_comment = PositionalComment.create_with_comment( params, current_user, @picture)
    
    PositionalComment.new_user_activity_for_new_comment( EVENT_TYPE[:create_comment],
                                                current_user, 
                                                @positional_comment.comment , 
                                                @picture ,
                                                 @picture.project )
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
    
    
  end
end
