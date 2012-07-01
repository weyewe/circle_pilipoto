require 'open-uri'
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
  
  def last_approved_revision
    last_revision_id = self.original_picture.approved_revision_id
    if last_revision_id.nil?
      return self.original_picture
    else
      return Picture.find_by_id( last_revision_id )
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

=begin
  The previous revision
=end

  def prev_revision_id_list 
    
    original = self.original_picture 
    array =  [original.id]
    
    if self.is_original?
      return array
    else
      return array + original.revisions.where(:is_deleted => false ) .order("created_at ASC").map{|x| x.id}
    end
  end
  
  

  def prev_revision
    if self.is_original?
      return nil
    else
      id_list = prev_revision_id_list
      current_revision_index = id_list.index( self.id )
      
      if current_revision_index > 0 
        return Picture.find_by_id(  id_list.at( current_revision_index - 1 )   ) 
      else
        return Picture.find_by_id(  id_list.at( current_revision_index   )   )  
      end
    end
  end


=begin
  company-admin large view mode
=end

  def next_pic_large_view_company_admin
    original_pic = self.original_picture
    # id_list = original_pic.project_submission.original_pictures_id
    id_list = original_pic.project.pictures.
                      where(:is_original => true, :is_deleted => false ).
                      order("created_at ASC") .map {|x| x.id }

    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index <  ( id_list.length - 1 )
      return  Picture.find_by_id( id_list.at ( current_pic_index + 1  ) ).last_revision 
    else
      return nil 
    end
  end

  def prev_pic_large_view_company_admin
    original_pic = self.original_picture
    # id_list = original_pic.project_submission.original_pictures_id
    id_list = original_pic.project.pictures.
                      where(:is_original => true, :is_deleted => false   ).
                      order("created_at ASC").map {|x| x.id}

    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index > 0 
      return Picture.find_by_id(  id_list.at( current_pic_index - 1 )   ).last_revision
    else
      return nil 
    end
  end
  
  
=begin
  selection mode
=end
  def next_pic_selection_mode
    picture_id_list = self.project.pictures.where(:is_deleted => false).order("created_at ASC").map {|x| x.id }
    self.nav_next_pic( picture_id_list)
  end
  
  def prev_pic_selection_mode
    picture_id_list = self.project.pictures.where(:is_deleted => false).order("created_at ASC").map {|x| x.id }
    self.nav_prev_pic( picture_id_list)
  end

=begin
  finalization mode
=end

  def next_pic
    original_pic = self.original_picture
    # id_list = original_pic.project_submission.original_pictures_id
    id_list = original_pic.project.pictures.
                      where(:is_original => true, :is_deleted => false , :is_selected => true  ).
                      order("created_at ASC") .map {|x| x.id }

    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index <  ( id_list.length - 1 )
      return  Picture.find_by_id( id_list.at ( current_pic_index + 1  ) ).last_revision 
    else
      return nil 
    end
  end

  def prev_pic
    original_pic = self.original_picture
    # id_list = original_pic.project_submission.original_pictures_id
    id_list = original_pic.project.pictures.
                      where(:is_original => true, :is_deleted => false, :is_selected => true   ).
                      order("created_at ASC").map {|x| x.id}
                      
    current_pic_index = id_list.index( original_pic.id )

    if current_pic_index > 0 
      return Picture.find_by_id(  id_list.at( current_pic_index - 1 )   ).last_revision
    else
      return nil 
    end
  end

  def Picture.create_from_assembly_url(assembly_url, project)
    pic = Picture.create(:assembly_url => assembly_url, :is_completed => false , :project_id => project.id)
    
    pic.delay.extract_from_assembly_url
    return pic
  end
  
  def Picture.assembled_pic_id_from( pic_id_list ) 
    Picture.find(:all, :conditions => {
      :id => pic_id_list, 
      :is_completed => true 
    }).map{|x| x.id }
  end
  
  
  def transloadit_params
    content = open(self.assembly_url).read

    transloadit_params = ActiveSupport::HashWithIndifferentAccess.new(
    ActiveSupport::JSON.decode content
    )
  end
  
  def extract_from_assembly_url
    content = open(self.assembly_url).read
    # json = JSON.parse(content)
    
    
    
    transloadit_params = ActiveSupport::HashWithIndifferentAccess.new(
          ActiveSupport::JSON.decode content
        )
        
    while transloadit_params[:ok] != "ASSEMBLY_COMPLETED"
      sleep 2
      puts "in the loop"
      content = open(self.assembly_url).read
      transloadit_params = ActiveSupport::HashWithIndifferentAccess.new(
            ActiveSupport::JSON.decode content
          )
    end

    self.original_image_url  = transloadit_params[:results][':original'].first[:url]
    self.index_image_url     = transloadit_params[:results][:resize_index].first[:url]   
    self.revision_image_url  = transloadit_params[:results][:resize_revision].first[:url] 
    self.display_image_url   = transloadit_params[:results][:resize_show].first[:url]     
    self.article_image_url   = transloadit_params[:results][:resize_article].first[:url]   
    self.original_image_size = transloadit_params[:results][':original'].first[:size]
    self.index_image_size    = transloadit_params[:results][:resize_index].first[:size]         
    self.revision_image_size = transloadit_params[:results][:resize_revision].first[:size]               
    self.display_image_size  = transloadit_params[:results][:resize_show].first[:size]                
    self.article_image_size  = transloadit_params[:results][:resize_article].first[:size]    
    self.name                = transloadit_params[:results][':original'].first[:name]
    self.is_original         = true 
    self.width               = transloadit_params[:results][':original'].first[:meta][:width]
    self.height              = transloadit_params[:results][':original'].first[:meta][:height] 
    self.is_completed        = true
    self.save
      
  end


  def self.extract_uploads(resize_original, resize_index , resize_show, resize_revision, 
    resize_article,
    params, uploads , current_user  )
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
        article_image_url = ""
        original_image_size    = ""
        index_image_size       = ""
        revision_image_size    = ""
        display_image_size     = ""
        article_image_size = ""
        original_width = ""
        original_height ="" 


        resize_original.each do |r_index|
          if r_index[:original_id] == original_id 
            original_image_url  = r_index[:url]
            original_image_size = r_index[:size]
            original_width  = r_index[:meta][:width]
            original_height = r_index[:meta][:height]
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
        
        #  resize article_display 
        resize_article.each do |r_index|
          if r_index[:original_id] == original_id 
             article_image_url  = r_index[:url]
             article_image_size = r_index[:size]
            break
          end
        end

        new_picture = Picture.create(
             :original_image_url => original_image_url     ,
             :index_image_url    =>   index_image_url      ,
             :revision_image_url =>   revision_image_url   ,
             :display_image_url  =>  display_image_url     ,
             :article_image_url =>  article_image_url,
             :project_id => project.id, 
             :original_image_size    => original_image_size      ,
             :index_image_size       => index_image_size         ,
             :revision_image_size    => revision_image_size      ,
             :display_image_size     => display_image_size       ,
             :article_image_size =>  article_image_size,
             :name => image_name,
             :is_original => true ,
             :width => original_width,
             :height => original_height ,
             :is_completed => true 
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
      article_image_size   = resize_article.first[:size]
      article_image_url   = resize_article.first[:url]
      width = resize_original.first[:meta][:width]
      height = resize_original.first[:meta][:height]
      
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
           :original_id => original_picture.id,
           :article_image_url => article_image_url,
           :article_image_size => article_image_size ,
           :width => width,
           :height => height ,
           :is_completed => true 
      )
      
      new_picture.is_selected = true
      new_picture.save

      # #  for the UserActivity
         UserActivity.create_new_entry(
                            EVENT_TYPE[:submit_picture_revision], 
                            current_user ,  #actor
                            new_picture ,   # first subject 
                            original_picture, # secondary subject
                            new_picture.project   )
      # 
      #   project_submission.update_submission_data( new_picture )
    end




    return new_picture
  end

  def self.new_user_activity_for_grading( event_type, grader, subject, secondary_subject, project )
    UserActivity.create_new_entry(event_type , 
                        grader , 
                        subject , 
                        secondary_subject,
                        project  )
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
        Project.delay.send_ready_to_be_finalized_email(project)
        # but, no finalization. finalization required the User to select. 
      end
    elsif action == REJECT_SUBMISSION
      self.is_approved = false
      self.save
    end
  end
end
