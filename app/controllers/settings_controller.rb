class SettingsController < ApplicationController
   layout 'layouts/settings'
   
   def timezone_setup
     # if current user is not school admin, kick out
     # if not current_user.has_role?(:school_admin)
     #   redirect_to root_url
     #   return
     # end

     @user = current_user 
   end
   
   def execute_timezone_setup
     # if not current_user.has_role?(:school_admin)
     #   redirect_to root_url
     #   return
     # end

     # @school = current_user.get_managed_school


     if current_user.set_time_zone( params[:time_zone]) 
       flash[:notice] = "Timezone is changed"
     else
       flash[:error] = "Failed to change timezone"
     end

     redirect_to timezone_setup_url
   end
   
   def delivery_method_setup
     # if not current_user.has_role?(:school_admin)
     #   redirect_to root_url
     #   return
     # end

     @user = current_user
   end
   
   def execute_delivery_method_setup
     # if not current_user.has_role?(:school_admin)
     #   redirect_to root_url
     #   return
     # end

     @selected_delivery_method = params[:delivery_method].to_i
     @delivery_hours = []

     if @selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:instant]
     elsif @selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:scheduled] 
       if params[:school].nil? || params[:school][:scheduled_delivery_hours].nil?
         redirect_to delivery_method_setup_url
         return
       end
       params[:school][:scheduled_delivery_hours].each do |x|
         @delivery_hours << x.to_i
       end
     end

     @school = current_user.get_managed_school
     @school.set_delivery_method( @selected_delivery_method, @delivery_hours)

     redirect_to delivery_method_setup_url
   end
end
