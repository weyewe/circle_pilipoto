class UserActivity < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  
  # after_create :deliver_update
  
  
  # in pilipoto, it is always linked with project. where can we create the project id ? 
  # we have the project id.
  
  
  def self.create_new_entry(event, actor, subject , secondary_subject, project)
    options = {}
    options[:event_type] = event 
    options[:actor_type] = actor.class.to_s
    options[:actor_id]  = actor.id 
    
    options[:subject_type] = subject.class.to_s
    options[:subject_id]  = subject.id 
    options[:project_id] = project.id
    
    if not secondary_subject.nil?
      # for example: willy replied on your comment -> 
        # what is affected => subject (comment), is created  as a reply for the root comment 
        # => the root comment is affected as well since it has extra reply now 
      options[:secondary_subject_type]  = secondary_subject.class.to_s
      options[:secondary_subject_id]  = secondary_subject.id 
    end
    
    # puts "Gonna create in create_new_entry\n"*10
    result = self.create( options ) 
     # puts "Done creation, gonna send update now \n"*10
    result.deliver_update
    
    return result 
    
   
          
  end
  
  def deliver_update
    # if Rails.env.production?
      self.delay.send_user_activity_update
    # elsif Rails.env.development?
      # self.send_user_activity_update
    # end
  end
  
  
=begin
  Extracting the value 
    Actor (the one who did something to subject)
    Subject ( the one who receive an action from actor)
    Secondary subject ( the collateral impact )
=end
  def extract_object(symbol)
    symbol = symbol.to_s
    extraction_type = "#{symbol}_type"
    extraction_id = "#{symbol}_id"
    
    extraction_class = eval( "self." + "#{extraction_type}")
    
    extraction_id = eval( "self." + "#{extraction_id}" )
    if extraction_class.nil? or extraction_id.nil?
      return nil
    end
    command = "#{extraction_class}" + "." + "find_by_id(#{extraction_id})"
    puts command 
    object =   eval( command )
    
    return object
  end

=begin
a  = UserActivity.find(:first, :conditions => {
  :event_type => EVENT_TYPE[:submit_picture]
})
=end

  
  
  def mark_notification_sent
    self.is_notification_sent = true
    self.save 
  end
  
  
  
  def extract_recipient
    
    @actor = self.extract_object :actor
    @subject = self.extract_object :subject
    @secondary_subject = self.extract_object :secondary_subject
    @project = Project.find_by_id self.project_id 
    
    puts "the actor is #{self.actor_type}  "
    puts "the actor is #{actor}"
    
    
    puts "The subject is #{@subject}"
    puts "The secondary_subject is #{@secondary_subject}"
    puts "The project is #{@project}"
    case self.event_type
  
        
    when EVENT_TYPE[:create_comment]
      # actor is the teacher # wrong .. actor is the user, can be teacher or student 
      # subject is the comment 
      # secondary subject is the picture
      # @user = @secondary_subject.project_submission.user 
      #       return [@user.email ]
      
 
      project_membership_list = []
      @project.project_memberships.each do |project_membership|
        if project_membership.user_id == @actor.id
          next
        else
          project_membership_list << project_membership
        end
      end
                    
      email_list = project_membership_list.map do |project_membership|
        project_membership.user.email 
      end

      return email_list
                       
 
    when EVENT_TYPE[:reply_comment]
      
      project_membership_list = []
      @project.project_memberships.each do |project_membership|
        if project_membership.user_id == @actor.id
          next
        else
          project_membership_list << project_membership
        end
      end
                    
      email_list = project_membership_list.map do |project_membership|
        project_membership.user.email 
      end

      return email_list
      
    when EVENT_TYPE[:submit_picture] 
      # nope, we are not updating the initial picture submit 
      
    when EVENT_TYPE[:submit_picture_revision]
      # actor is the  (uploader) -> employee or company admin 
      # subject is the new uploaded picture 
      # secondary_subject is the original_picture
      
      project_membership_list = []
      @project.project_memberships.each do |project_membership|
        if project_membership.user_id == @actor.id
          next
        else
          project_membership_list << project_membership
        end
      end
                    
      email_list = project_membership_list.map do |project_membership|
        project_membership.user.email 
      end

      return email_list
      
      
      
    when EVENT_TYPE[:grade_picture]
      project_membership_list = []
      @project.project_memberships.each do |project_membership|
        if project_membership.user_id == @actor.id
          next
        else
          project_membership_list << project_membership
        end
      end
                    
      email_list = project_membership_list.map do |project_membership|
        project_membership.user.email 
      end

      return email_list
                     
    when EVENT_TYPE[:create_project]
      # 
    else
    end
    
    
  end
  
  # protected
  
  def self.send_summary
    NewsletterMailer.send_summary("rajakuraemas@gmail.com").deliver
  end

  def send_user_activity_update
    
    puts "We are inside the send_user_activityy_update\n"*5
    # check if it is development Rails.env.development? 
    # Check if it is production: Rails.env.production? 
    recipients = self.extract_recipient 
    
    if ( not recipients.nil?) and (recipients.length > 0 )  
        # if SNIFFING == 1 
        #        recipients << "rajakuraemas@gmail.com"
        #      end
      
        recipients.each do |recipient| 
          
          recipient_user = User.find_by_email recipient 
          
          if recipient_user.delivery_method == NOTIFICATION_DELIVERY_METHOD[:scheduled]
            PolledDelivery.create :user_activity_id => self.id , 
                                  :recipient_email => recipient,
                                  :notification_raised_datetime => DateTime.now
          elsif  recipient_user.delivery_method == NOTIFICATION_DELIVERY_METHOD[:instant] 
            NewsletterMailer.activity_update( recipient , Time.now, self).deliver
          end
        end
    end
  end
end
