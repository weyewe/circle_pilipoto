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
