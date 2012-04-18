class ArticlePicture < ActiveRecord::Base
  # width : 870px ( in the article display )
  
  
  def is_front_page_grade?
    ( not self.front_page_width.nil? ) and ( not self.front_page_height.nil? ) and 
    ( self.front_page_width == FRONT_PAGE_IMAGE_WIDTH )  and
    ( self.front_page_height == FRONT_PAGE_IMAGE_HEIGHT)
  end



  def self.extract_uploads(resize_original, resize_index , 
                    resize_front_page, resize_article, 
                    params, uploads )
    article = Article.find_by_id(params[:article_id] )
    

    new_picture = ""
    image_name = ""
    # if params[:is_original].to_i == ORIGINAL_PICTURE 
      counter = 0 

      # start looping all the transloadit data
      uploads.each do |upload|
        original_id = upload[:original_id]

        original_image_url  = ""
        index_image_url     = ""
        article_image_url = ""
        front_page_image_url = ""
        
        
        original_image_size    = ""
        index_image_size       = ""
        article_image_size = ""
        front_page_image_size = ""
        
        
        original_width = ""
        original_height ="" 
        front_page_width = ""
        front_page_height = ""


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

        #  resize article_display 
        resize_article.each do |r_index|
          if r_index[:original_id] == original_id 
             article_image_url  = r_index[:url]
             article_image_size = r_index[:size]
            break
          end
        end
        
        resize_front_page.each do |r_index|
          if r_index[:original_id] == original_id 
             front_page_image_url  = r_index[:url]
             front_page_image_size = r_index[:size]
             front_page_width =  r_index[:meta][:width]
             front_page_height = r_index[:meta][:height]
            break
          end
        end

        new_picture = ArticlePicture.create(
           :name                          =>  image_name                                ,
           :article_id                    =>  article.id                                ,
           :original_image_url            =>  original_image_url                        ,
           :article_image_url             =>  article_image_url                         ,
           :front_page_image_url          =>  front_page_image_url                      ,
           :index_image_url               =>  index_image_url                           ,
           :original_image_size           =>  original_image_size                       ,
           :article_image_size            =>  article_image_size                        ,
           :front_page_image_size         =>  front_page_image_size                     ,
           :index_image_size              =>  index_image_size                          ,
           :article_picture_type          =>  ARTICLE_PICTURE_TYPE[:pure_article_upload],
           :width                         =>  original_width                            ,
           :height                        =>  original_height                           ,
           :front_page_width              =>  front_page_width                          ,
           :front_page_height             =>  front_page_height          
        )

        counter =  counter + 1 

     
      end #end of uploads loop
      
      
    # end
    
    return new_picture
  end
  
  
  def is_selected_for_front_page?
    self.is_selected_front_page == true 
  end
  
  
  def set_as_front_page
    self.is_selected_front_page = true 
    self.save
  end
  
  def remove_from_front_page
    self.is_selected_front_page  = false
    self.save
  end
  
end
