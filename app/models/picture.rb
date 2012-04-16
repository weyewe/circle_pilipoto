class Picture < ActiveRecord::Base
  belongs_to :user 
  belongs_to :project 
  
  
  has_many :revisions, :class_name => "Revision"
   belongs_to :original_picture, :class_name => "Revision",
     :foreign_key => "original_picture_id"

   # for the picture has many revisions
   has_many :revisionships
   has_many :revisions, :through => :revisionships
   has_many :inverse_revisionships, :class_name => "Revisionship", :foreign_key => "revision_id"
   has_many :inverse_revisions, :through => :inverse_revisionships, :source => :picture  
   
   attr_protected :is_selected, :is_deleted
   # t.boolean  "is_deleted",           :default => false
   #    t.boolean  "is_selected",          :default => false
   #    t.boolean  "is_original",          :default => false
   #    t.boolean  "is_approved"
   #    t.integer  "approved_revision_id"
   #    t.integer  "original_id"

=begin
  The commenting logic. 
  Only teacher that can add positional comments 
=end
  acts_as_commentable
  # has_many :comments
  has_many :positional_comments

  def is_original?
    self.is_original 
  end

  def any_picture_submission_approved?
    self.original_picture.approved_revision_id != nil
  end


  def original_picture
    if self.is_original == true 
      return self
    else
      Picture.find_by_id( self.original_id )
      # return self.inverse_revisions.first
    end
  end

  def approved_picture
    Picture.find_by_id( self.original_picture.approved_revision_id )
  end
  
  def last_approved_revision
    last_revision_id = self.original_picture.approved_revision_id
    if last_revision_id.nil?
      return self.original_picture
    else
      return Picture.find_by_id( last_revision_id )
    end
  end
  
  

  def last_revision
    last_revision  = self.original_picture.revisions.last 
    if last_revision.nil?
      return self.original_picture
    else
      return last_revision 
    end
  end

  # restrict commenting capability to several people 
  def allow_comment?(user) 
    # for now, we allow everyone
    return true 
  end
  
  def is_selected?
    self.is_selected == true
  end
  
  def set_selected_value( decision ) 
    if not self.project.is_picture_selection_done?
      if decision == TRUE_CHECK and self.project.can_select_more_pic? 
          self.is_selected = true 
      end
    
      if decision == FALSE_CHECK
        self.is_selected = false 
      end
      self.save
    end
  end


  # def get_root_comments
  #   comment_type = self.class.to_s
  #   Comment.find(:all, :conditions => {:commentable_type => comment_type,
  #       :commentable_id => self.id, 
  #       :parent_id => nil } , :order => "created_at ASC"  )
  # end

=begin
  For storage calculation 
=end

  def images_size
    self.original_image_size + 
      self.byproduct_image_size
  end

  def byproduct_to_original_ratio
    self.byproduct_image_size / self.original_image_size.to_f
  end

  def byproduct_image_size
    self.display_image_size + 
      self.index_image_size + 
        self.revision_image_size
  end


=begin
  For picture navigation with NEXT and PREV button
=end

  # we will have 2 kind of next => 
  # => 1. picture navigation in all uploaded images
  # => 2. picture navigation in all the selected images 
  
  def nav_next_pic( in_all_selected )
    original_pic = self.original_picture
    id_list = original_pic.project.nav_original_pictures_id( in_all_selected )

    current_pic_index = id_list.index( original_pic.id )
    if current_pic_index <  ( id_list.length - 1 )
      return  Picture.find_by_id( id_list.at ( current_pic_index + 1  ) ).last_revision 
    else
      return nil 
    end
  end
  
  def nav_prev_pic( in_all_selected )
    original_pic = self.original_picture
    id_list = original_pic.project.nav_original_pictures_id( in_all_selected )

    current_pic_index = id_list.index( original_pic.id )
    
    if current_pic_index > 0 
      return Picture.find_by_id(  id_list.at( current_pic_index - 1 )   ).last_revision
    else
      return nil 
    end
  end

  def next_pic
    original_pic = self.original_picture
    id_list = original_pic.project_submission.original_pictures_id

    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index <  ( id_list.length - 1 )
      return  Picture.find_by_id( id_list.at ( current_pic_index + 1  ) ).last_revision 
    else
      return nil 
    end
  end

  def prev_pic
    original_pic = self.original_picture
    id_list = original_pic.project_submission.original_pictures_id
    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index > 0 
      return Picture.find_by_id(  id_list.at( current_pic_index - 1 )   ).last_revision
    else
      return nil 
    end
  end




  def self.extract_uploads(resize_original, resize_index , resize_show, resize_revision, params, uploads )
    project = Project.find_by_id(params[:project_id] )

    new_picture = ""
    image_name = ""
    if params[:is_original].to_i == ORIGINAL_PICTURE 
      counter = 0 

      # start looping all the transloadit data
      uploads.each do |upload|
        original_id = upload[:original_id]

        original_image_url  = ""
        index_image_url     = ""
        revision_image_url  = ""
        display_image_url   = ""
        original_image_size    = ""
        index_image_size       = ""
        revision_image_size    = ""
        display_image_size     = ""


        resize_original.each do |r_index|
          if r_index[:original_id] == original_id 
            original_image_url  = r_index[:url]
            original_image_size = r_index[:size]
            image_name = r_index[:name]
            break
          end
        end


        resize_index.each do |r_index|
          if r_index[:original_id] == original_id 
            index_image_url  = r_index[:url]
            index_image_size = r_index[:size]
            break
          end
        end

        resize_show.each do |s_index|
          if s_index[:original_id] == original_id 
            display_image_url  = s_index[:url]
            display_image_size  = s_index[:size]
            break
          end
        end


        resize_revision.each do |s_index|
          if s_index[:original_id] == original_id 
            revision_image_url  = s_index[:url]
            revision_image_size  = s_index[:size]
            break
          end
        end

        new_picture = Picture.create(
             :original_image_url => original_image_url     ,
             :index_image_url    =>   index_image_url      ,
             :revision_image_url =>   revision_image_url   ,
             :display_image_url  =>  display_image_url     ,
             :project_id => project.id, 
             :original_image_size    => original_image_size      ,
             :index_image_size       => index_image_size         ,
             :revision_image_size    => revision_image_size      ,
             :display_image_size     => display_image_size       ,
             :name => image_name,
             :is_original => true 
        )

        counter =  counter + 1 

        #  for the UserActivity timeline event 
        # UserActivity.create_new_entry(EVENT_TYPE[:submit_picture], 
        #                         project_submission.user , 
        #                         new_picture , 
        #                         project_submission.project  )

        # project_submission.update_submission_data( new_picture )
      end
    elsif params[:is_original].to_i == REVISION_PICTURE
      original_picture = Picture.find_by_id(params[:original_picture_id])
      original_image_url  = resize_original.first[:url]
      index_image_url     = resize_index.first[:url]
      revision_image_url  = resize_revision.first[:url]
      display_image_url   = resize_show.first[:url]
      original_image_size    = resize_original.first[:size]
      index_image_size       = resize_index.first[:size]   
      revision_image_size    = resize_revision.first[:size]
      display_image_size     = resize_show.first[:size]    

      # index_picture_url = resize_index.first[:url]
      # show_picture_url = resize_show.first[:url]
      image_name = resize_show.first[:name]
      new_picture = original_picture.revisions.create(
           :original_image_url => original_image_url     ,
           :index_image_url    =>   index_image_url      ,
           :revision_image_url =>   revision_image_url   ,
           :display_image_url  =>  display_image_url     ,
           :project_id => project.id, 
           :original_image_size    => original_image_size      ,
           :index_image_size       => index_image_size         ,
           :revision_image_size    => revision_image_size      ,
           :display_image_size     => display_image_size       ,
           :name => image_name,
           :original_id => original_picture.id
      )

      # #  for the UserActivity
      #    UserActivity.create_new_entry(EVENT_TYPE[:submit_picture_revision], 
      #                       project_submission.user , 
      #                       new_picture , 
      #                       original_picture  )
      # 
      #   project_submission.update_submission_data( new_picture )
    end




    return new_picture
  end

  def self.new_user_activity_for_grading( event_type, grader, subject, secondary_subject )
    UserActivity.create_new_entry(event_type , 
                        grader , 
                        subject , 
                        secondary_subject  )
  end

=begin
  Approval 
=end

  def set_approval( action ) 
    if action == ACCEPT_SUBMISSION
    #  approve the image 
      self.is_approved = true 
      self.save
      
    # link it to original picture 
      original_picture = self.original_picture
      original_picture.approved_revision_id = self.id
      original_picture.save 
      
      
      # create checker.. if all the selections are approved, send email to the project owner 
      project= self.project
      if project.ready_to_be_finalized? 
        puts "gonna send email 3321. And the picture of the selected"
        # but, no finalization. finalization required the User to select. 
      end
    elsif action == REJECT_SUBMISSION
      self.is_approved = false
      self.save
    end
  end


end
