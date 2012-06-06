class PicturesController < ApplicationController
  def new
    @project = Project.find_by_id( params[:project_id] )
    @pictures = @project.original_pictures.where(:is_completed => true ).includes(:revisions).order("name ASC")
    @new_picture = Picture.new
    ensure_project_membership
    
    
    
    add_breadcrumb "Select  project", 'select_project_to_be_managed_path'
    set_breadcrumb_for @project, 'new_project_picture_path' + "(#{@project.id})", 
          "Add Pictures for #{@project.title}"
  end
  
  def create_picture_from_assembly
    @project = Project.find_by_id( params[:project_id] )
    assembly_url = params[:assembly_url]
    ensure_project_membership
    
    @picture = Picture.create_from_assembly_url(assembly_url, @project)
    
    respond_to do |format| 
      format.js do 
        is_completed_result = 0 
        if @picture.is_completed == true
          is_completed_result= 1
        end
        render :json => {'picture_id' => @picture.id, 'is_completed' => is_completed_result}.to_json  
      end
    end
  end
  
  def transloadit_status_for_picture
    # @picture = Picture.find_by_id( params[:picture_id])
    array_of_assembled_pic_id = Picture.assembled_pic_id_from( params[:non_completed_pic_id_list].split(",").map{|x| x.to_i })
      
    
    
    respond_to do |format| 
      format.js do 
        # is_completed_result = 0 
        # if @picture.is_completed == true
        #   is_completed_result= 1
        # end
        render :json => array_of_assembled_pic_id.to_json  
      end
    end
  end
  
  def update_transloadit_processing_status
    @picture_id_value_list = JSON.parse(params[:picture_id_value_list])
    
    
    # {
    #    picture_id : 1_or_0
    #  }
  end
  
  
  def create
    
    @project = Project.find_by_id( params[:project_id] )
    ensure_project_membership
    
    new_picture = ""
    if not params[:transloadit].nil?
      new_picture = Picture.extract_uploads( 
        params[:transloadit][:results][":original".to_sym],
        params[:transloadit][:results][:resize_index], 
        params[:transloadit][:results][:resize_show], 
        params[:transloadit][:results][:resize_revision], 
        params[:transloadit][:results][:resize_article], 
        params, params[:transloadit][:uploads] , current_user )
    end 
    
    
    if not params[:is_original].nil? and params[:is_original].to_i == FALSE_CHECK
      redirect_to  show_picture_for_feedback_url(new_picture) 
       # show_picture_for_feedback_url( params[:original_picture_id ] )
    elsif not params[:is_original].nil? and params[:is_original].to_i == TRUE_CHECK
      redirect_to new_project_picture_url( @project  )#
    end
         # 
         #  if params[:from_project_owner].nil?
         #    # it is from new picture page
         # #   redirect_to new_project_submission_picture_path(@project_submission)
         #  else 
         #    # it is to create revision
         #    # only the owner that can upload images 
         #    redirect_to new_project_picture_url(@project)
         #  end
  end
  


=begin
  For Collaboration : client and collaborator 
=end

  def select_pictures_for_project
    @project = Project.find_by_id( params[:project_id])
    @pictures = @project.original_pictures
    # @project_membership = @project.get_project_membership_for( current_user )
    ensure_project_membership
    
    if @project.done_with_selection == true 
      redirect_to finalize_pictures_for_project_url(@project)
    else
      
      add_breadcrumb "Select  project", 'select_project_for_collaboration_path'
      set_breadcrumb_for @project, 'select_pictures_for_project_path' + "(#{@project.id})", 
            "Select Pictures for #{@project.title}"
    end
  end
  
  
  
  def execute_select_picture
    @project = Project.find_by_id( params[:membership_provider])
    @picture = Picture.find_by_id( params[:membership_consumer])
    ensure_project_membership
    
    if not params[:membership_decision].nil?
      @picture.set_selected_value( params[:membership_decision].to_i )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url } 
      format.js
    end
  end
  
  
  def large_picture_preview_for_selection
    @picture = Picture.find_by_id( params[:picture_id])
    @project = @picture.project 
    # @project_membership = @project.get_project_membership_for( current_user )
    ensure_project_membership
    
    add_breadcrumb "Select  project", 'select_project_for_collaboration_path'
    set_breadcrumb_for @project, 'select_pictures_for_project_path' + "(#{@project.id})", 
          "Select Pictures for #{@project.title}"
    set_breadcrumb_for @project, 'large_picture_preview_for_selection_url' + "(#{@picture.id})", 
          "Large Preview"    
        
          
          
    
  end
  
  
  
  def execute_picture_selection_from_large_picture_preview
    @project = Project.find_by_id( params[:membership_provider])
    @picture = Picture.find_by_id( params[:membership_consumer])
    ensure_project_membership
    
    if not params[:membership_decision].nil?
      @picture.set_selected_value( params[:membership_decision].to_i )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url } 
      format.js
    end
  end
  
  
=begin
  The real shit: uploading revision, adding comment, etc
=end
  def finalize_pictures_for_project
    @project  = Project.find_by_id( params[:project_id])
    @project_membership = @project.get_project_membership_for( current_user )
    @pictures = @project.selected_original_pictures
    
    ensure_project_membership
    
    
    finalize_text = "" 
    
    if @project_membership.has_role?(:client)
      finalize_text = "Finalize "
    elsif @project_membership.has_role?(:collaborator) or @project_membership.has_role?(:owner)
      finalize_text = "Select picture to review "
    end
    
    add_breadcrumb "Select  project", 'select_project_for_collaboration_path'
    set_breadcrumb_for @project, 'finalize_pictures_for_project_path' + "(#{@project.id})", 
          "#{finalize_text}for: #{@project.title}"
          
  end
  
  def show_picture_for_feedback
    
    @picture  = Picture.find_by_id(params[:picture_id])
    @project = @picture.project
    ensure_project_membership
    # @project_membership = @project.get_project_membership_for( current_user )
    @original_picture = @picture.original_picture
    @all_revisions = @original_picture.revisions.order("created_at DESC")
    @root_comments = @picture.root_comments.order("created_at ASC")
    
    
    
    finalize_text = "" 
    feedback_text = ""
    
    if @project_membership.has_role?(:client)
      finalize_text = "Finalize"
      feedback_text = "Give Feedback"
    elsif @project_membership.has_role?(:collaborator) or @project_membership.has_role?(:owner)
      finalize_text = "Select picture to review "
      feedback_text = "Review Feedbacks"
    end
    
    
  
    add_breadcrumb "Select  project", 'select_project_for_collaboration_path'
    set_breadcrumb_for @project, 'finalize_pictures_for_project_path' + "(#{@project.id})", 
          "#{finalize_text}  for: #{@project.title}"
    set_breadcrumb_for @picture, 'show_picture_for_feedback_path' + "(#{@picture.id})", 
          "#{feedback_text}"
  end
  
  
=begin
  For the approval 
=end
  def execute_grading
    
    # if not current_user.has_role?(:teacher)
    #       redirect_to root_url
    #       return
    #     end
    
    # ensure_role(:teacher) # ensuring role is not enough. further information is needed , like project ownership
    # if we are only protecting in the role level, what if there is a corrupted user? 
    # we are doomed 
    @picture = Picture.find_by_id(params[:picture_id])
    # @original_picture = @picture.original_picture
    # @project = @picture.project
    @project = @picture.project
    ensure_project_membership
    
    
    # if @project.nil? or not @project.created_by?(current_user)
    #      redirect_to root_url 
    #      return 
    #    end
 
    @picture.set_approval(  params[:picture][:is_approved].to_i  )
    
    
    
    # if params[:picture][:is_approved].to_i == ACCEPT_SUBMISSION
    #     @picture.is_approved = true 
    #     # @picture.score = params[:picture][:score]
    #     @picture.save
    #     @original_picture.approved_revision_id = @picture.id 
    #     @original_picture.save 
    #     # @project_submission.update_score 
    #     # @project_submission.update_total_project_score  
    #     # total project score only be generated when the project is closed by the teacher. 
    #     # the engine will calculate the final value -> sum n submissions score / n
    #     
    #   elsif params[:picture][:is_approved].to_i == REJECT_SUBMISSION
    #     @picture.is_approved = false
    #     # @picture.score = params[:picture][:score]
    #     @picture.save
    #   else
    #   end
    #   
    Picture.new_user_activity_for_grading(
        EVENT_TYPE[:grade_picture],
        current_user ,  #this is the teacher
        @picture,  #picture being graded
        nil,
        @picture.project   #the project where that picture belongs to 
      )
    
    # create checking for the whole selections.. if all of them are approved, send notification to the owner 
    # Project.check_finalization_completion( @picture.project )
    # Project.trigger_all_pictures_finalized_notification
    
    respond_to do |format|
      format.html {  redirect_to project_submission_picture_path(@picture ,@picture) }
      format.js
    end
  end
  
  
  
=begin
  company admin, view the uploaded pictures
=end

  def large_picture_preview_for_company_admin
    
    
    @picture = Picture.find_by_id(params[:picture_id])
    @project = @picture.project
    # @project_membership =   @project.get_project_membership_for(current_user)
    ensure_project_membership
  end
  
 
  
  
end
