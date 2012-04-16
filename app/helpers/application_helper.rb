module ApplicationHelper
  ACTIVE = 'active'
  REVISION_SELECTED = "selected"
  NEXT_BUTTON_TEXT = "Next &rarr;"
  PREV_BUTTON_TEXT = " &larr; Prev "
  
  
  
=begin
  For Collaboration process nav, determining the view link for :client and :collaborator 
=end
  def extract_relevant_collaboration_link(user, project)
    project_membership = ProjectMembership.find(:first, :conditions => {
      :project_id => project.id,
      :user_id => user.id 
    })
    
   
    if not project.is_picture_selection_done?
      select_pictures_for_project_url( project  )
    else
      finalize_pictures_for_project_url(project)
    end
   
  
    
  end
  
  
  def add_project_closed_class(project)
    if project.is_picture_selection_done?
      return "closed-project"
    else
      ""
    end
  end
  
=begin
  For the grade display 
=end
  def get_colspan( closed_projects )
    length = closed_projects.length
    if length == 0 
      return 1 
    else
      return length 
    end
  end
  
  def extract_project_submission_result( result , student, project ) 
    if result.nil?
      return '-'
    else
      return  result #link_to result, show_project_grading_details_url(project, student )
    end
  end

=begin
  Getting prev and next button for the pictures#show
=end
  def get_next_project_picture( pic , is_grading_mode)
    next_pic = pic.next_pic
    
    if not next_pic.nil?
      destination_url = ""
      if not is_grading_mode
        destination_url = project_submission_picture_url( pic.project_submission, next_pic)
      else
        destination_url = grade_project_submission_picture_url( next_pic ) 
      end
      
      
      return  create_galery_navigation_button( NEXT_BUTTON_TEXT, "next",destination_url )
    else
      ""
    end
  end
  
  def get_previous_project_picture( pic , is_grading_mode )
    prev_pic = pic.prev_pic
    
    if not prev_pic.nil?
      
      destination_url = ""
      if not is_grading_mode
        destination_url = project_submission_picture_url( pic.project_submission, prev_pic)
      else
        destination_url = grade_project_submission_picture_url( prev_pic ) 
      end
      
      
      return  create_galery_navigation_button( PREV_BUTTON_TEXT, "previous", destination_url)
      
    else
      ""
    end
    
  end
  
  
  
  def create_galery_navigation_button( text, class_name, destination_url )
    button = ""
    button << "<li class=#{class_name}>"
    button << link_to("#{text}".html_safe, destination_url )
    button << "</li>"
    
  end
  
  # <li class="previous">
  #   <a href="#">&larr; Prev</a>
  # </li>
  # <li class="next">
  #   <a href="#">Next &rarr;</a>
  # </li>
  
  
  
=begin
  Showing the revisions in the pictures#show
=end
  
  def class_for_current_displayed_revision(revision, current_display)
    if revision.id == current_display.id 
      return REVISION_SELECTED
    else
      return ""
    end
  end
  
=begin
  Assigning activity:
  1. Assigning student to the class
  2. Assigning teacher to the course etc
=end
  
  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
  
=begin
  General command to create Guide in all pages
=end 
  def create_guide(title, description)
    result = ""
    result << "<div class='explanation-unit'>"
    result << "<h1>#{title}</h1>"
    result << "<p>#{description}</p>"
    result << "</div>"
  end
  
  def create_breadcrumb(breadcrumbs)
    
    if (  breadcrumbs.nil? ) || ( breadcrumbs.length ==  0) 
      # no breadcrumb. don't create 
    else
      breadcrumbs_result = ""
      breadcrumbs_result << "<ul class='breadcrumb'>"
      
      puts "After the first"
      
      
      breadcrumbs[0..-2].each do |txt, path|
        breadcrumbs_result  << create_breadcrumb_element(    link_to( txt, path ) ) 
      end 
      
      puts "After the loop"
      
      last_text = breadcrumbs.last.first
      last_path = breadcrumbs.last.last
      breadcrumbs_result << create_final_breadcrumb_element( link_to( last_text, last_path)  )
      breadcrumbs_result << "</ul>"
      return breadcrumbs_result
    end
    
    
  end
  
  def create_breadcrumb_element( link ) 
    element = ""
    element << "<li>"
    element << link
    element << "<span class='divider'>/</span>"
    element << "</li>"
    
    return element 
  end
  
  def create_final_breadcrumb_element( link )
    element = ""
    element << "<li class='active'>"
    element << link 
    element << "</li>"
    
    return element
  end
  
  
  
  
  

  
  
  
  
  
  
  
  
=begin
  Process Navigation related activity
=end  

  
  def get_process_nav( symbol, params)
    
    if symbol == :project_setup
      return create_process_nav(PROJECT_SETUP_PROCESS_LIST, params )
    end
    
    if symbol == :project_management
      return create_process_nav(PROJECT_MANAGEMENT_PROCESS_LIST, params )
    end
    
    if symbol == :collaboration 
      return create_process_nav(COLLABORATION_PROCESS_LIST, params )
    end
    
    if symbol == :marketing 
      return create_process_nav(MARKETING_PROCESS_LIST, params )
    end
    
    
    
    if symbol == :teacher
      return create_process_nav(TEACHER_PROCESS_LIST, params )
    end
    
    if symbol == :submission_grading 
      return create_process_nav(SUBMISSION_GRADING_PROCESS_LIST, params )
    end
    
    if symbol == :student 
      return create_process_nav(STUDENT_PROCESS_LIST, params )
    end
  end
  
  
  
  
  protected 
  
  #######################################################
  #####
  #####     Start of the process navigation code 
  #####
  #######################################################
   
  def create_process_nav( process_list, params )
     result = ""
     result << "<ul class='nav nav-list'>"
     result << "<li class='nav-header'>  "  + 
                 process_list[:header_title] + 
                 "</li>"         

     process_list[:processes].each do |process|
       result << create_process_entry( process, params )
     end

     result << "</ul>"

     return result
   end
   
   
  
  
  
  def create_process_entry( process, params )
    is_active = is_process_active?( process[:conditions], params)
    
    process_entry = ""
    process_entry << "<li class='#{is_active}'>" + 
                      link_to( process[:title] , extract_url( process[:destination_link] )    )
    
    return process_entry
  end
  
  def is_process_active?( active_conditions, params  )
    active_conditions.each do |condition|
      if condition[:controller] == params[:controller] &&
        condition[:action] == params[:action]
        return ACTIVE
      end

    end

    return ""
  end
  
  def extract_url( some_url )
    if some_url == '#'
      return '#'
    end
    
    eval( some_url ) 
  end
  
  
  
  #######################################################
  #####
  #####     Start of the process navigation KONSTANT
  #####
  #######################################################
  
  PROJECT_SETUP_PROCESS_LIST = {
    :header_title => "Project Setup",
    :processes => [
     {
       :title => "Create Project",
       :destination_link => "new_project_url",
       :conditions => [
         {
           :controller => 'projects', 
           :action => 'new'
         },
         {
           :controller => "projects",
           :action => 'create'
         }
       ]

     },
     {
      :title => "Edit Project",
      :destination_link => "root_url",
      :conditions => [
        {
          :controller => '', 
          :action => ''
        },
        {
          :controller => '',
          :action => ''
        }
          ]
      }
    ]
  }
    
  PROJECT_MANAGEMENT_PROCESS_LIST = {
    :header_title => "Project Management",
    :processes => [
      {
        :title => "Monitor Project",
        :destination_link => 'select_project_to_be_managed_url', 
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_to_be_managed'
          },
          {
            :controller => "pictures",
            :action => 'new'
          }
        ]
      },
      {
        :title => "Invite Member",
        :destination_link => 'select_project_to_invite_member_url',
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_to_invite_member'
          },
          {
            :controller => 'projects',
            :action => 'invite_member_for_project'
          }
        ]
      },
      {
        :title => "Remove Member",
        :destination_link => 'root_url',
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      },
      {
        :title => "Finalized Projects",
        :destination_link => 'show_finalized_projects_url',
        :conditions => [
          {
            :controller => 'projects',
            :action => 'show_finalized_projects'
          }
        ]
      }
      
    ]
  }
  
  
  COLLABORATION_PROCESS_LIST = {
    :header_title => "Collaboration",
    :processes => [
      {
        :title => "Select Project",
        :destination_link => 'select_project_for_collaboration_url', 
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_for_collaboration'
          },
          {
            :controller => "pictures",
            :action => "select_pictures_for_project"
          },
          {
            :controller => "pictures",
            :action => "finalize_pictures_for_project"
          },
          {
            :controller => "pictures",
            :action => "show_picture_for_feedback"
          }
        ]
      }
      
    ]
  }
    
  HISTORY_PROCESS_LIST = {
    :header_title => "History",
    :processes => [
      {
        :title => "Active Subjects",
        :destination_link => "active_subjects_management_url", 
        :conditions => [
          {
            :controller => 'subjects',
            :action => 'active_subjects_management'
          },
          {
            :controller => 'subjects',
            :action => 'duplicate_active_subject'
          }
        ]
      },
      {
        :title => "Past Subjects",
        :destination_link => "passive_subjects_management_url",
        :conditions => [
          {
            :controller => 'subjects',
            :action => 'passive_subjects_management'
          },
          {
            :controller => "subjects",
            :action => 'duplicate_passive_subject'
          }
        ]
      }
    ]
  }
  
  
  MARKETING_PROCESS_LIST = {
    :header_title => "Page Management",
    :processes => [
      {
        :title => "Homepage Images",
        :destination_link => "", 
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => '',
            :action => ''
          }
        ]
      },
      {
        :title => "Result Publishing",
        :destination_link => "",
        :conditions => [
          {
            :controller => '',
            :action => ''
          },
          {
            :controller => "",
            :action => ''
          }
        ]
      }
    ]
  }
  
  
    
    
  TEACHER_PROCESS_LIST = {
    :header_title => "TEACHER",
    :processes => [
     {
       :title => "Create Project",
       :destination_link => "select_subject_for_project_url",
       :conditions => [
         {
           :controller => "projects", 
           :action => "select_subject_for_project"
         },
         {
            :controller => "projects", 
            :action => "select_course_for_project"
         }, 
         {
             :controller => "projects", 
             :action => "new"
         }
       ]
     },
     {
       :title => "Create Group",
       :destination_link => "select_subject_for_group_url",
       :conditions => [
         {
           :controller => "groups",
           :action => "select_subject_for_group"
         },
         {
           :controller => "groups",
           :action => "select_course_for_group"
         },
         {
           :controller => "groups",
           :action => "new"
         }
       ]
     },
     {
       :title => "Assign Student to Group",
       :destination_link => "select_subject_for_group_membership_path",
       :conditions => [
         {
           :controller => "group_memberships",
           :action => "select_subject_for_group_membership"
         },
         {
           :controller => "group_memberships",
           :action => "select_course_for_group_membership"
         },
         {
           :controller => "group_memberships",
           :action => "select_group"
         },
         {
           :controller => "group_memberships",
           :action => "new"
         }
       ]
     },
     {
       :title => "Select Group Leader",
       :destination_link => "select_group_for_group_leader_path",
       :conditions => [
         {
           :controller => "groups",
           :action => "select_group_for_group_leader"
         },
         {
           :controller => "groups",
           :action => "select_group_leader"
         }
       ]
     }
    ]
  }
  
  STUDENT_PROCESS_LIST = {
    :header_title => "Student",
    :processes => [
      {
        :title => "Ongoing Projects",
        :destination_link => 'project_submissions_url',
        :conditions => [
          {
            :controller => "project_submissions",
            :action => "index"
          },
          {
            :controller =>"pictures",
            :action => "new"
          },
          {
            :controller => "pictures",
            :action => "show"
          }
        ]
      }
    ]
  }
  
  SUBMISSION_GRADING_PROCESS_LIST = {
    :header_title => "Project Submission",
    :processes => [
      {
        :title => "Active Projects: Grading",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => 'projects',
            :action => 'select_project_for_grading'
          },
          {
            :controller => 'project_submissions',
            :action => 'select_project_submission_for_grading'
          },
          {
            :controller => 'project_submissions',
            :action => 'show_submission_pictures_for_grading'
          },
          {
            :controller => 'pictures',
            :action => 'grade_project_submission_picture'
          }
        ]
      },
      {
        :title => "Past Projects",
        :destination_link => 'past_projects_url' ,
        :conditions => [
          :controller => 'projects',
          :action => 'past_projects'
        ]
      },
      {
        :title => "Grade Summary",
        :destination_link => 'select_course_for_grade_summary_url',
        :conditions => [
          {
            :controller => 'courses',
            :action => 'select_course_for_grade_summary'
          },
          {
            :controller => 'courses',
            :action => 'show_student_grades_for_course'
          }
        ]
      },
      {
        :title => "Recent Submission",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      },
      {
        :title => "Recent Comments",
        :destination_link => "select_project_for_grading_url",
        :conditions => [
          {
            :controller => '',
            :action => ''
          }
        ]
      }
    ]
  }
  
end
