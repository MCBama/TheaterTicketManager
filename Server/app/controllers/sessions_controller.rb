class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting]
  #before_filter :save_login_state, :only => [:login, :login_attempt]
  
  def login
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      user = User.find_by_id(authorized_user.id)
      if user.account_level == "SysAdmin"
        redirect_to admin_control_path()
      elsif user.account_level == "OrgAdmin"
        organization = Organization.find_by_id(user.organization.id)
        redirect_to edit_organization_path(organization)
      else
        redirect_to root_path()
      end
    else
      flash[:warning] = "Invalid Username or Password"
      render "login"	
    end
  end
  
  def home
  end

  def profile
  end

  def setting
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end
end
