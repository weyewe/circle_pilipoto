desc "Resize image with lower quality"

# steps: clean duplicates
# then, do the final parsing 
task :buffer_pics => :environment do 
  filename = 'image_buffer.txt'
  Picture.all.each do |pic|
    
    
    File.open(Rails.root.to_s + "/lib/tasks/" + "#{filename}", 'a') do |f| 
      f.puts(pic.to_json) 
    end
  end
end


task :recreate_pictures_from_json => :environment do 
  require "json"
  # filename = 'image_buffer.txt'
  #  File.open(Rails.root.to_s + "/lib/tasks/" + "#{filename}", 'r') do |f| 
  #    f.puts(pic.to_json) 
  #  end
  #  
  filename = 'image_buffer.txt'
  file = File.new( Rails.root.to_s + "/lib/tasks/" + "#{filename}"  , "r")
  while (line = file.gets)
    # puts "#{counter}: #{line}"
    #    counter = counter + 1
    pic_hash = JSON.load line
    puts pic_hash
    a=  Picture.create( 
      :name                          =>         pic_hash[:name                            ]   ,
      :revision_id                   =>         pic_hash[:revision_id                     ]   ,
      :project_id                    =>         pic_hash[:project_id                      ]   ,
      :original_image_url            =>         pic_hash[:original_image_url              ]   ,
      :index_image_url               =>         pic_hash[:index_image_url                 ]   ,
      :revision_image_url            =>         pic_hash[:revision_image_url              ]   ,
      :display_image_url             =>         pic_hash[:display_image_url               ]   ,
      :original_image_size           =>         pic_hash[:original_image_size             ]   ,
      :index_image_size              =>         pic_hash[:index_image_size                ]   ,
      :revision_image_size           =>         pic_hash[:revision_image_size             ]   ,
      :display_image_size            =>         pic_hash[:display_image_size              ]   ,
      :is_original                   =>         pic_hash[:is_original                     ]   ,
      :is_approved                   =>         pic_hash[:is_approved                     ]   ,
      :approved_revision_id          =>         pic_hash[:approved_revision_id            ]   ,
      :original_id                   =>         pic_hash[:original_id                     ]   ,
      :score                         =>         pic_hash[:score                           ]   ,
      :user_id                       =>         pic_hash[:user_id                         ]   ,
      :width                         =>         pic_hash[:width                           ]   ,
      :height                        =>         pic_hash[:height                          ]   ,
      :front_page_article_image_url  =>         pic_hash[:front_page_article_image_url    ]   ,
      :front_page_article_image_size =>         pic_hash[:front_page_article_image_size   ]
    )
    a.is_deleted = pic_hash[:is_deleted]
    a.is_selected = pic_hash[:is_selected]
    a.save
    
    
  end
  file.close

    
end