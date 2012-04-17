# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Neopilipoto::Application.initialize!



ROLE_MAP = {
  :premium => "Premium",
  :standard => "Standard"
}

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
  :create_comment => 1,  # yes  # notification is working  #background notification is working 
  :reply_comment => 2,  # yes  #the view details depends on the destination
                        #  destination is working  # working total! 
  :submit_picture => 3 ,   #added  #notification is working  ## working with background job
  :submit_picture_revision => 4,  #added # notification is working  # working 
  :grade_picture => 5,  #reject is working  
  :create_project => 6   #added  # notification working  # working with background job
}



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

HOME_IMAGE_WIDTH = 1920
HOME_IMAGE_HEIGHT = 1080 
