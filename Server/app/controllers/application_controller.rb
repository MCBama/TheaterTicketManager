class ApplicationController < ActionController::Base
include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user
  
protected
  def authenticate_user
    if session[:user_id]
      # set current user object to @current_user object variable
      if (user = User.find_by_id session[:user_id])
        @current_user = user
      else
        session[:user_id]=nil
      end
      return true	
    else
      #redirect_to(:controller => 'sessions', :action => 'login')
      @current_user = User.generic_user
      return false
    end
  end
  
  def save_login_state
    if session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'home')
      return false
    else
      return true
    end
  end
  
end
