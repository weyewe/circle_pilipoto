class UserActivity < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  
  # after_create :deliver_update
  
  
  
  def self.create_new_entry(event, actor, subject , secondary_subject)
    options = {}
    options[:event_type] = event 
    options[:actor_type] = actor.class.to_s
    options[:actor_id]  = actor.id 
    
    options[:subject_type] = subject.class.to_s
    options[:subject_id]  = subject.id 
    
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
    
    case self.event_type
    when EVENT_TYPE[:create_comment]
      # actor is the teacher # wrong .. actor is the user, can be teacher or student 
      # subject is the comment 
      # secondary subject is the picture
      # @user = @secondary_subject.project_submission.user 
      #       return [@user.email ]
      
      if @actor.has_role?(:student)
        #student make comment for the teacher
        @course = @secondary_subject.project_submission.project.course 
        return [ CourseTeachingAssignment.find(:first, :conditions => {
                         :course_id => @course.id,
                         :is_active => true 
                       }).user.email ]
                       
      elsif @actor.has_role?(:teacher)
        #teacher make comment for the student 
        @user = @secondary_subject.project_submission.user 
        return [@user.email ]
      end
    when EVENT_TYPE[:reply_comment]
      # actor is the user, can be teacher or student   
      # the subject is the comment itself 
      # the  secondary_subject is the picture
      if @actor.has_role?(:student)
        #we have to get the teacher 
        @course = @secondary_subject.project_submission.project.course 
        # if 2 teachers are handling 1 class, use this method
        # @teachers  = CourseTeachingAssignment.find(:a, :conditions => {
        #          :course_id => @course.id,
        #          :is_active => true 
        #        }).map {|x|   x.user.email }
        #        
        #        return teachers
        
        
        
        return [ CourseTeachingAssignment.find(:first, :conditions => {
                         :course_id => @course.id,
                         :is_active => true 
                       }).user.email ] 
        
      elsif @actor.has_role?(:teacher)
        @user = @secondary_subject.project_submission.user
        return  [@user.email  ]
      else
        return [ "rajakuraemas@gmail.com" ]
      end  
      
      
    when EVENT_TYPE[:submit_picture] 
      # actor is the uploader (student ) 
      # subject  is the uploaded picture  itself 
      # secondary_subject is the project
      @course = @secondary_subject.course
      @teacher = CourseTeachingAssignment.find(:first, :conditions => {
        :course_id => @course.id
      }).user
      
      return [@teacher.email ] 
      
      
    when EVENT_TYPE[:submit_picture_revision]
      # actor is the student (uploader)
      # subject is the new uploaded picture 
      # secondary_subject is the original_picture
      
      @course = @secondary_subject.project_submission.project.course
      
      # original_picture.project_submission.project.course
      
      @teacher = CourseTeachingAssignment.find(:first, :conditions => {
        :course_id => @course.id
        }).user

      return [@teacher.email]
      
    when EVENT_TYPE[:grade_picture]
      # actor is the teacher
      # subject is the picture being graded
      # secondary_subject is the project
      @student = @subject.project_submission.user 
      return [@student.email ]
                     
    when EVENT_TYPE[:create_project]
      # actor is teacher (project_creator)
      # subject is the project being created
      # seconadary_subject is the course
      @students = @secondary_subject.students
      collection_of_students_email = @students.map {|x| x.email }
      return collection_of_students_email
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
        if SNIFFING == 1 
          recipients << "rajakuraemas@gmail.com"
        end
      
        recipients.each do |recipient| 
          #  if  recipient == teacher , don't send.
          recipient_user = User.find_by_email recipient 
          school  = recipient_user.get_managed_school
          
          puts ">>>>>>The email is #{recipient}\n"*5
          puts "The school delivery method is #{school.delivery_method}\n"*5
          
          if recipient_user.has_role?(:teacher) && 
              school.delivery_method == NOTIFICATION_DELIVERY_METHOD[:scheduled]
            puts "Gonna create Polled Delivery\n"*5
            PolledDelivery.create :user_activity_id => self.id , 
                                  :recipient_email => recipient,
                                  :notification_raised_datetime => DateTime.now
          elsif ( recipient_user.has_role?(:teacher ) && 
                  school.delivery_method == NOTIFICATION_DELIVERY_METHOD[:instant] )  or 
                ( recipient_user.has_role?(:student) )
                
                puts "****Gonna create the realtime \n"*5
            NewsletterMailer.activity_update( recipient , Time.now, self).deliver
            
          end
          # NewsletterMailer.activity_update( recipient , Time.now, self).deliver
        end
    end
  end
end
