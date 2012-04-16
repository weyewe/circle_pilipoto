Neopilipoto::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  
  match 'dashboard'           => 'home#dashboard'  , :as => :dashboard
  root :to => 'home#dashboard'
  
  resources :projects do 
    resources :pictures
  end
  
  
  
  # the commenting for pictures 
  resources :pictures do 
    resources :positional_comments
    resources :comments
  end
  
  
  
  # create child comment
  match 'first_child_comment/picture/:picture_id/comment/:root_comment_id' => "comments#create_first_child_comment", :as => :create_first_child_comment
  match 'create_child_comment/picture/:picture_id/comment/:root_comment_id' => "comments#create_child_comment", :as => :create_child_comment
  
=begin
  Invite Member to the project ( member can be a client or collaborator )
=end
 
  match 'select_project_to_invite_member' => "projects#select_project_to_invite_member", :as => :select_project_to_invite_member
  match 'invite_member_for_project/:project_id' => "projects#invite_member_for_project", :as => :invite_member_for_project
  match 'execute_project_invitation/:project_id' => "projects#execute_project_invitation" , :as => :execute_project_invitation
  
=begin
  Remove Member to the project ( member can be a client or collaborator )
=end

  match 'select_project_to_remove_member' => "projects#select_project_to_remove_member", :as => :select_project_to_remove_member
  match 'remove_member_for_project/:project_id' => "projects#remove_member_for_project", :as => :remove_member_for_project
  match 'execute_member_removal/:project_id' => "projects#execute_member_removal" , :as => :execute_member_removal

=begin
  Select Active projects to be managed
=end
  match 'select_project_to_be_managed' => "projects#select_project_to_be_managed", :as => :select_project_to_be_managed
  
  
=begin
  COllaboration process list 
=end
  match 'select_project_for_collaboration' => "projects#select_project_for_collaboration" , :as => :select_project_for_collaboration


  # for client collaboration 
  match 'select_pictures_for_project/:project_id' => "pictures#select_pictures_for_project", :as => :select_pictures_for_project
  match 'execute_select_picture' => "pictures#execute_select_picture", :as => :execute_select_picture
  match 'execute_project_selection_done' => "projects#execute_project_selection_done", :as => :execute_project_selection_done
  # approve or reject the final selection 
  match 'execute_grading/picture/:picture_id' => "pictures#execute_grading", :as => :execute_grading, :method => :post
  # finalize project
  match 'finalize_project' => "projects#finalize_project", :as => :finalize_project, :method => :post
  
  match 'show_finalized_projects' => "projects#show_finalized_projects", :as => :show_finalized_projects
  
  # finalize the selected picture -> Feedback, edit etc
  match 'finalize_pictures_for_project/:project_id' => "pictures#finalize_pictures_for_project", :as => :finalize_pictures_for_project
  match 'show_picture_for_feedback/:picture_id' => "pictures#show_picture_for_feedback", :as => :show_picture_for_feedback
  # match 'execute_select_picture' => "pictures#execute_select_picture", :as => :execute_select_picture
  # match 'execute_project_selection_done' => "projects#execute_project_selection_done", :as => :execute_project_selection_done
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
