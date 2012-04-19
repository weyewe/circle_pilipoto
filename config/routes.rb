Neopilipoto::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  
 
  
  root :to => 'home#homepage'
  match 'works' => "home#article_list", :as => :past_works
  
  match 'dashboard'           => 'home#dashboard'  , :as => :dashboard
 
  
  resources :projects do 
    resources :pictures
  end
  
  match 'select_project_to_be_edited' => 'projects#select_project_to_be_edited' , :as => :select_project_to_be_edited
  
  resources :articles do 
    resources :article_pictures
  end
  
  
  
=begin
  creating article from project 
=end
  match 'select_project_to_create_article' => 'projects#select_project_to_create_article', :as => :select_project_to_create_article
  match 'create_article_from_project' => 'articles#create_article_from_project', :as => :create_article_from_project
  # fill in the description , title, teaser 
  match 'edit_article_content/:article_id' => 'articles#edit_article_content', :as => :edit_article_content
  match 'update_article_content/:article_id' => 'articles#update_article_content', :as => :update_article_content
  # add the display images
  
  
  match 'edit_image_ordering/:article_id' => 'articles#edit_image_ordering', :as => :edit_image_ordering
  match 'update_image_ordering/:article_id' => 'articles#update_image_ordering', :as => :update_image_ordering
  
  
  match 'edit_publication/:article_id' => 'articles#edit_publication', :as => :edit_publication
  match 'update_publication/:article_id' => "articles#update_publication", :as => :update_publication , :method => :post
  
  match 'select_article_to_upload_for_front_page_image' => 'articles#select_article_to_upload_for_front_page_image', :as => :select_article_to_upload_for_front_page_image
  match 'select_or_upload_front_page_image' => 'articles#select_or_upload_front_page_image', :as => :select_or_upload_front_page_image
  # match 'upload_front_page_image' => 'articles#upload_front_page_image', :as => :upload_front_page_image

  match 'execute_select_front_page' => "article_pictures#execute_select_front_page", :as => :execute_select_front_page, :method => :post 
  
  match 'new_independent_article' => 'articles#new_independent_article', :as => :new_independent_article
  
  
  
  
=begin
  Creating a brand new article, independent from the project
=end
  
  
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
  
=begin
  Finalize Project
=end
  match 'finalize_project' => "projects#finalize_project", :as => :finalize_project
  match 'select_project_to_be_de_finalized' => "projects#select_project_to_be_de_finalized", :as => :select_project_to_be_de_finalized
  match 'de_finalize_project' => "projects#de_finalize_project", :as => :de_finalize_project
  
  
  
  
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
