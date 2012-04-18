class NewsletterMailer < ActionMailer::Base
  # helper UserActivityMailerHelper
  default :css => :bootstrap_email , from: "admin@potoschool.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.newsletter_mailer.weekly.subject
  #
  
  
  def welcome_email
    mail(:to => "rajakuraemas@gmail.com", :subject => "Welcome to My Awesome Site")
  end

    
=begin
  New User Registration, Course Registration, Subject Registration,
  Course Teaching Assignment, Subject Teaching Assignment
=end
  def importing_update( email_list )
    @failed_registrations = FailedRegistration.all 
    # email_list.each do | email | 
      mail( :to  => email_list, 
      :subject => "potoSchool | Tarumanegara Failed Registration #{Time.now}" )
    # end
  end
  
  
  def notify_new_user_registration( user , password ) 
    @password = password 
    @user = user 
    @school = user.get_enrolled_school
    
    mail( :to  => user.email, 
    :subject => "potoSchool | Pendaftaran #{@school.name}  " ,
     :bcc => ["rajakuraemas@gmail.com", "christian@potoschool.com"] )
    
    # mail( :to  => "w.yunnal@potoschool.com", 
    #    :subject => "potoSchool | Pendaftaran #{@school.name}  " )
  end
  
  # notify course registration
  def notify_course_registration( user , course ) 
    @course = course
    @subject = @course.subject 
    @school = @subject.school
    @user = user 

    mail( :to  => user.email, 
    :subject => "potoSchool | Registrasi Pelajaran #{@subject.name}, kelas #{@course.name}  " )
  end
  
  
  
  # notify course teaching assignmnet 
  def notify_course_teaching_assignment( user , course ) 
    @course = course
    @subject = @course.subject 
    @school = @subject.school
    @user = user
    mail( :to  => user.email, 
    :subject => "potoSchool | Tuga Mengajar pelajaran #{@subject.name}, kelas #{@course.name}  " )
  end


=begin
  Typical Instant Activity updates 
=end
  
  def activity_update(email, time, user_activity )
    extract_params(user_activity) 
    @user_activity = user_activity
    
    mail( :to  => email, 
    :subject => "potoSchool | Tarumanegara Updates new #{time}", 
    :bcc => ["rajakuraemas@gmail.com", "christian@potoschool.com"] )
    
    user_activity.mark_notification_sent 
  end
  
=begin
  The polled Activity Update
=end

  def polled_delivery( recipient_email , pending_deliveries )
    @recipient_email = recipient_email 
    @user = User.find_by_email @recipient_email 
    @school  = @user.get_managed_school
    @pending_deliveries = pending_deliveries
    time = Time.now
    
    mail( :to  => recipient_email, 
    :subject => "potoSchool | #{@school.name} Updates (#{pending_deliveries.count}): #{time}", 
    :bcc => ["rajakuraemas@gmail.com", "christian@potoschool.com"] )
    
  end
  
  
  def send_summary(email)
    mail(:to => email , 
    :subject => "potoSchool | Summary Tarumangara @#{Time.now}")
  end
  
  
  def extract_params(user_activity)
    @actor = user_activity.extract_object(:actor)
    @subject_object = user_activity.extract_object(:subject)

    @secondary_subject = user_activity.extract_object(:secondary_subject)
    @event_type = user_activity.event_type
  end
  
  def send_statistic(course, subject)
    puts "gonna send the sendStatistic"
    
    @course = course
    #  of course, the subject will be nill in the view because 
    # there is method called subject
    @subject = subject
    @school = @subject.school 
    
    puts "the course #{@course}"
    puts "the subject #{@subject}"
    puts "the subject name: #{@subject.name}"
    puts "the school #{@school}"
    @subject_object = @subject
    
    # , "christian.tanudjaja@gmail.com"
    mail(:to => ["rajakuraemas@gmail.com" , "christian.tanudjaja@gmail.com"] , 
    :subject => "potoSchool | Summary Users #{@school.name} @#{Time.now}")
  end
end
