# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Neopilipoto::Application.initialize!



# ROLE_MAP = {
#   :company_admin => "CompanyAdmin",
#   :employee => "Employee", 
#   :client => "Client"
# }
SNIFFING = 1 
ROLE_MAP = {
  :company_admin => "CompanyAdmin",
  :standard => "Standard"
}

# in the company wide, there can only be 2 role maps: company_admin , or standard_user 
# in project, they might be collaborator and client 

=begin
  new role-structure
  :company_admin
  :employee
  :client
=end

PROJECT_ROLE_MAP = {
  :client => "Client",
  :collaborator => "Collaborator",
  :owner => "Owner"
}

INVITE_AS_CLIENT = "client"
INVITE_AS_COLLABORATOR = "collaborator"


TRUE_CHECK = 1
FALSE_CHECK = 0


ORIGINAL_PICTURE   = 1
REVISION_PICTURE   = 0

NORMAL_COMMENT     = 0
POSITIONAL_COMMENT = 1

ACCEPT_SUBMISSION = 1
REJECT_SUBMISSION = 0

ADD_GROUP_LEADER = 1 
REMOVE_GROUP_LEADER = 0

DEFAULT_DEADLINE_HOUR = 23
DEFAULT_DEADLINE_MINUTE = 59 


DISPLAY_IMAGE_WIDTH = 590

EVENT_TYPE  = {                
  :create_comment => 1, 
  :reply_comment => 2,  
                        
  :submit_picture => 3 ,   
  :submit_picture_revision => 4,
  :grade_picture => 5,  
  :create_project => 6 ,
  
  :submit_document_original => 100,
  :submit_document_revision => 101,
  
  :add_new_user => 500, # not user activity.. just a registration 
  :assign_project_role => 501,
    
  :done_with_picture_selection => 601
}

# grade_pic_events = UserActivity.find(:all, :conditions =>  { :event_type => EVENT_TYPE[:grade_picture],
#   :is_notification_sent => false 
# })



=begin
  Images store in amazon s3
=end

DUMMY_PROFILE_PIC={
  :medium => "",
  :small => ""
}

POSITIONAL_FEEDBACK_MARKER = ''

# use this constant to adjust images , premium pilipoto 
HYPER_PREMIUM_DEPLOYMENT = true


ARTICLE_TYPE = {
  :mapped_from_project => 1 , 
  :independent_article =>  2
}



THUMB_IMAGE_ARRAY = ["http://s3.amazonaws.com/circle-static-thumb/slide_01_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_02_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_03_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_04_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_05_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_06_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_07_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_08_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_09_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_10_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_11_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_12_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_13_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_14_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_15_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_16_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_17_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_18_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_19_thb.jpg", "http://s3.amazonaws.com/circle-static-thumb/slide_20_thb.jpg"] 
IMAGE_ARRAY =  ["http://s3.amazonaws.com/circle-static/slide_01.jpg", "http://s3.amazonaws.com/circle-static/slide_02.jpg", "http://s3.amazonaws.com/circle-static/slide_03.jpg", "http://s3.amazonaws.com/circle-static/slide_04.jpg", "http://s3.amazonaws.com/circle-static/slide_05.jpg", "http://s3.amazonaws.com/circle-static/slide_06.jpg", "http://s3.amazonaws.com/circle-static/slide_07.jpg", "http://s3.amazonaws.com/circle-static/slide_08.jpg", "http://s3.amazonaws.com/circle-static/slide_09.jpg", "http://s3.amazonaws.com/circle-static/slide_10.jpg", "http://s3.amazonaws.com/circle-static/slide_11.jpg", "http://s3.amazonaws.com/circle-static/slide_12.jpg", "http://s3.amazonaws.com/circle-static/slide_13.jpg", "http://s3.amazonaws.com/circle-static/slide_14.jpg", "http://s3.amazonaws.com/circle-static/slide_15.jpg", "http://s3.amazonaws.com/circle-static/slide_16.jpg", "http://s3.amazonaws.com/circle-static/slide_17.jpg", "http://s3.amazonaws.com/circle-static/slide_18.jpg", "http://s3.amazonaws.com/circle-static/slide_19.jpg", "http://s3.amazonaws.com/circle-static/slide_20.jpg"] 

STATIC_IMAGE = {
  :logo => "http://s3.amazonaws.com/circle-static-assets/logo.png",
  :pauseplay =>  "http://s3.amazonaws.com/circle-static-assets/pause.png",
  :playpause => "http://s3.amazonaws.com/circle-static-assets/play.png",
  :social_facebook_small => "http://s3.amazonaws.com/circle-static-assets/social_facebook_small.png",
  :social_twitter_small => "http://s3.amazonaws.com/circle-static-assets/social_twitter_small.png",
  :social_linkedin_small => "http://s3.amazonaws.com/circle-static-assets/social_linkin_small.png",
  :button_tray_up => "http://s3.amazonaws.com/circle-static-assets/button-tray-up.png",
  :button_tray_down => "http://s3.amazonaws.com/circle-static-assets/button-tray-down.png"
}


ASSET= ["http://s3.amazonaws.com/circle-static-assets/back.png", "http://s3.amazonaws.com/circle-static-assets/bg-black.png", "http://s3.amazonaws.com/circle-static-assets/bg-hover.png", "http://s3.amazonaws.com/circle-static-assets/button-tray-down.png", "http://s3.amazonaws.com/circle-static-assets/button-tray-up.png", "http://s3.amazonaws.com/circle-static-assets/forward.png", "http://s3.amazonaws.com/circle-static-assets/help.png", "http://s3.amazonaws.com/circle-static-assets/icon_check.png", "http://s3.amazonaws.com/circle-static-assets/icon_comments.png", "http://s3.amazonaws.com/circle-static-assets/icon_loveit.png", "http://s3.amazonaws.com/circle-static-assets/icon_minus.png", "http://s3.amazonaws.com/circle-static-assets/icon_minus2.png", "http://s3.amazonaws.com/circle-static-assets/icon_plus.png", "http://s3.amazonaws.com/circle-static-assets/icon_plus2.png", "http://s3.amazonaws.com/circle-static-assets/icon_quotes.png", "http://s3.amazonaws.com/circle-static-assets/icon_rss.png", "http://s3.amazonaws.com/circle-static-assets/icon_x.png", "http://s3.amazonaws.com/circle-static-assets/item_zoom.png", "http://s3.amazonaws.com/circle-static-assets/logo.png", "http://s3.amazonaws.com/circle-static-assets/magnifier.png", "http://s3.amazonaws.com/circle-static-assets/nav-bg.png", "http://s3.amazonaws.com/circle-static-assets/nav-dot.png", "http://s3.amazonaws.com/circle-static-assets/page_white_code.png", "http://s3.amazonaws.com/circle-static-assets/page_white_copy.png", "http://s3.amazonaws.com/circle-static-assets/pause.png", "http://s3.amazonaws.com/circle-static-assets/play.png", "http://s3.amazonaws.com/circle-static-assets/printer.png", "http://s3.amazonaws.com/circle-static-assets/progress.gif", "http://s3.amazonaws.com/circle-static-assets/social_da.png", "http://s3.amazonaws.com/circle-static-assets/social_facebook.png", "http://s3.amazonaws.com/circle-static-assets/social_facebook_mid.png", "http://s3.amazonaws.com/circle-static-assets/social_facebook_small.png", "http://s3.amazonaws.com/circle-static-assets/social_flickr.png", "http://s3.amazonaws.com/circle-static-assets/social_linkin_mid.png", "http://s3.amazonaws.com/circle-static-assets/social_linkin_small.png", "http://s3.amazonaws.com/circle-static-assets/social_twitter.png", "http://s3.amazonaws.com/circle-static-assets/social_twitter_mid.png", "http://s3.amazonaws.com/circle-static-assets/social_twitter_small.png", "http://s3.amazonaws.com/circle-static-assets/thumb-back.png", "http://s3.amazonaws.com/circle-static-assets/thumb-forward.png"] 


WORK_CATEGORY = ["LANDSCAPE & NATURE", 
  "COMMERCIAL",
  "PORTRAITS & PEOPLE",
  "WEDDING PHOTOGRAHY",
  "PERSONAL PROJECTS",
  "VIDEO SHOOTING"
]

FRONT_PAGE_IMAGE_WIDTH = 1920
FRONT_PAGE_IMAGE_HEIGHT = 1080 


ARTICLE_PICTURE_TYPE = {
  :migrated_from_project => 1 ,
  :pure_article_upload => 2 
}


JAKARTA_HOUR_OFFSET = 7 
=begin
  For company setup 
=end


TOWN_OFFSET_HASH = {"Samoa"=>-11, " International Date Line West"=>-11, " Midway Island"=>-11, "Hawaii"=>-10, "Alaska"=>-9, "Pacific Time (US & Canada)"=>-8, " Tijuana"=>-8, "Mountain Time (US & Canada)"=>-7, " Arizona"=>-7, " Chihuahua"=>-7, " Mazatlan"=>-7, 
  "Central Time (US & Canada) "=>-6, "Central America"=>-6, " Guadalajara"=>-6, " Mexico City"=>-6, 
  " Monterrey"=>-6, " Saskatchewan"=>-6, "Eastern Time (US & Canada)"=>-5, " Bogota"=>-5, 
  " Indiana (East)"=>-5, " Lima"=>-5, " Quito"=>-5, "Caracas"=>-4.5, "Atlantic Time (Canada)"=>-4, 
  "Georgetown"=>-4, " La Paz"=>-4, " Santiago"=>-4, "Newfoundland"=>-3.5, "Buenos Aires"=>-3,
  "Brasilia"=>-3, " Greenland"=>-3, "Mid-Atlantic"=>-2, "Cape Verde Is."=>-1, "Azores"=>-1, "London"=>0, 
  " Casablanca"=>0, " Dublin"=>0, " Edinburgh"=>0, " Lisbon"=>0, " Monrovia"=>0, " UTC"=>0, "Paris"=>1, 
  "Amsterdam"=>1, " Belgrade"=>1, " Berlin"=>1, " Bern"=>1, " Bratislava"=>1, " Brussels"=>1, " Budapest"=>1,
  " Copenhagen"=>1, " Ljubljana"=>1, " Madrid"=>1, " Prague"=>1, " Rome"=>1, " Sarajevo"=>1, " Skopje"=>1,
  " Stockholm"=>1, " Vienna"=>1, " Warsaw"=>1, " West Central Africa"=>1, " Zagreb"=>1, "Cairo"=>2,
  "Athens"=>2, " Bucharest"=>2, " Harare"=>2, " Helsinki"=>2, " Istanbul"=>2, " Jerusalem"=>2,
  " Kyiv"=>2, " Minsk"=>2, " Pretoria"=>2, " Riga"=>2, " Sofia"=>2, " Tallinn"=>2, " Vilnius"=>2, 
  "Moscow"=>3, "Baghdad"=>3, " Kuwait"=>3, " Nairobi"=>3, " Riyadh"=>3, " St. Petersburg"=>3,
  " Volgograd"=>3, "Tehran"=>3.5, "Baku"=>4, "Abu Dhabi"=>4, " Muscat"=>4, " Tbilisi"=>4,
  " Yerevan"=>4, "Kabul"=>4.5, "Karachi"=>5, "Ekaterinburg"=>5, " Islamabad"=>5, " Tashkent"=>5, 
  "Mumbai"=>5.5, "Chennai"=>5.5, " Kolkata"=>5.5, " New Delhi"=>5.5, " Sri Jayawardenepura"=>5.5, 
  "Kathmandu"=>5.75, "Dhaka"=>6, "Almaty"=>6, " Astana"=>6, " Novosibirsk"=>6, "Rangoon"=>6.5, 
  "Jakarta"=>7, "Bangkok"=>7, " Hanoi"=>7, " Krasnoyarsk"=>7, "Hong Kong"=>8, "Beijing"=>8, " Chongqing"=>8, 
  " Irkutsk"=>8, " Kuala Lumpur"=>8, " Perth"=>8, " Singapore"=>8, " Taipei"=>8, " Ulaan Bataar"=>8,
  " Urumqi"=>8, "Tokyo"=>9, "Osaka"=>9, " Sapporo"=>9, " Seoul"=>9, " Yakutsk"=>9, "Adelaide"=>9.5, 
  "Darwin"=>9.5, "Sydney"=>10, "Brisbane"=>10, " Canberra"=>10, " Guam"=>10, " Hobart"=>10, 
  " Melbourne"=>10, " Port Moresby"=>10, " Vladivostok"=>10, "Solomon Is."=>11, "Kamchatka"=>11,
  " Magadan"=>11, " New Caledonia"=>11, "Auckland"=>12, "Fiji"=>12, " Marshall Is."=>12,
  " Wellington"=>12, "Nuku'alofa"=>13} 
  
POSITIONAL_COMMENT_MARKER_WIDTH = 44  # 52 - 4padding*2   << left and right

NOTIFICATION_DELIVERY_METHOD = {
  :instant => 1, 
  :scheduled => 2
}

AVATAR_IMAGE = "https://s3.amazonaws.com/potoschool_icon/default_profile_pic.jpg"

TRANSLOADIT_UPLOAD_URL = "http://api2.transloadit.com/assemblies"
UPLOADIFY_SWF_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify.swf"
UPLOADIFY_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"

UPLOADIFIVE_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"

# PRELOADER_URL = "http://s3.amazonaws.com/circle-static-assets/287.png"

PRELOADER_URL = "http://s3.amazonaws.com/circle-static-assets/ajax-loader.gif"


SPECIAL_LOGIN = ["w.yunnal@gmail.com", "christian.tanudjaja@gmail.com", "rajakuraemas@gmail.com"]

# PILIPOTO features
PILIPOTO_FEATURES= {
  :streamlined_image_repository => "http://s3.amazonaws.com/circle-static-assets/premium_feature/streamlined_project_repo.jpg",
  :online_client_image_selection => "http://s3.amazonaws.com/circle-static-assets/premium_feature/client_selection.jpg",
  :on_pic_commenting => "http://s3.amazonaws.com/circle-static-assets/premium_feature/on_pic_commenting.jpg",
  :centralized_communication => "http://s3.amazonaws.com/circle-static-assets/premium_feature/centralized_comm.jpg",
  :revision_tracking => "http://s3.amazonaws.com/circle-static-assets/premium_feature/revision_tracking.jpg"
}

FANCYBOX_ASSET_URL = {
  :blank_gif => 'http://s3.amazonaws.com/circle-static-assets/fancybox/blank.gif',
  :fancybox_loading => 'http://s3.amazonaws.com/circle-static-assets/fancybox/fancybox_loading.gif',
  :fancybox_sprite => 'http://s3.amazonaws.com/circle-static-assets/fancybox/fancybox_sprite.png'
}

