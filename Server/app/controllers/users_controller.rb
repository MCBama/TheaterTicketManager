class UsersController < ApplicationController
  
  #before_filter :save_login_state, :only => [:new, :create]
  
  def index
    if @current_user && @current_user.administrator?
      
    else
      flash[:error] = "You don't have access rights to that page"
      redirect_to root_path()
    end
  end
  
  def new
    @user = User.new
  end
  
  def part_two
    @user_params = user_params
  end
  
  def create
    @user = User.new(name: params[:user][:name], encrypted_credit_card: params[:user][:encrypted_credit_card], username: params[:username], email: params[:email],
      password:params[:password], password_confirmation: params[:password_confirmation])
    hash = account_params
    hash[:password_confirmation] = params[:password_confirmation]
    if @user.update(hash)
      session[:user_id] = @user.id
      flash[:notice] = "Successfully signed up!"
      redirect_to user_path(@user)
    else
      setup_errors(@user)
      render :new
    end
  end
  
  def edit
    @user = User.find_by_id(params[:id])
  end
  
  def edit_information
    @user = User.find_by_id(params[:id])
  end
    
  def update_information
    @user = User.find_by_id(params[:id])
    if params[:user][:encrypted_credit_card].include?("XXXXXXX") && params[:user][:encrypted_credit_card].include?(@user.last_four)
      params[:user][:encrypted_credit_card] = @user.encrypted_credit_card
    end
    
    if @user.match_password(params[:user][:password_confirmation])
      params[:user][:password] = params[:user][:password_confirmation]
      @user.password = params[:user][:password_confirmation]
    else
      setup_errors(@user)
    end
    
    unless @user.update(account_params)
      setup_errors(@user)
      redirect_to user_path(@user)
    else
      flash[:notice] = "Success"
      redirect_to user_path(@user)
    end
  
  end
    
  def update
    @user = User.find_by_id(params[:id])
    if @current_user == @user or @current_user.administrator?
     
      if @current_user.match_password(params[:user][:old_password]) or @current_user.administrator?
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        @user.username = params[:user][:username]
        unless @user.save
          setup_errors(@user)
        else
          flash[:notice] = "Successfully Updated account"
        end
      else
        flash[:error] = "Old password not correct"
      end
      if params[:call_location] == "admin_control"
        redirect_to admin_control_path
      elsif params[:call_location] == "teller"
        redirect_to root_path
      else
        redirect_to user_path(@user)
      end
    else
      setup_errors(@user)
      redirect_to root_path()
    end
    
    
  end
  
  def show
      @user = User.find_by_id(params[:id])
      unless @current_user == @user or @current_user.administrator?
        flash[:error]="You don't have access to this page"
        redirect_to root_path
      end
  end
  
  def admin_control
    unless @current_user.administrator?
      flash[:error]="You do not have administration rights"
      redirect_to root_path()
    end
    @organization_list = Organization.all
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end
  
  def admin_edit
    @user=User.find_by_id(params[:id])
  end
  
private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :salt, :encrypted_password, :account_level)
  end
  
  def account_params
    params.require(:user).permit(:encrypted_credit_card, :address, :name, :password_confirmation, :password, :street_address, :city, :state)
  end
    
end
