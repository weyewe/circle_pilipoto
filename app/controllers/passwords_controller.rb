class PasswordsController < ApplicationController

  def edit
    @filter ="credential"
    @user = current_user
    @profile = current_user.profile
  end
  
  def edit_credential
    @user = current_user 
    # @profile = current_user.profile 
    
    render :layout => 'layouts/settings'
  end

  def update
    @user = current_user

    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      flash[:notice] = "Password is updated successfully."
    else
      flash[:error] = "Fail to update password. Check your input!"
    end
    
    redirect_to edit_credential_url
    
  end
  
  def edit_username
    @user = current_user
    @profile = current_user.profile
  end
  
  protected
  # def filter_all_except_password( params[:user] )
  #   
  # end
end