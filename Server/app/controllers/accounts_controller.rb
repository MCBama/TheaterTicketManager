class AccountsController < ApplicationController
  def login
    @user = User.new
  end
  
  def new 
    @account = Account.new
    if @current_user.organization && @current_user.administrator?(@current_user.organization.id)
      render :new_admin
    end
  end
  
  def new_admin
    
  end 
  
  def edit
    @account = Account.find_by_id(params[:id])
  end
  
  def update
    account = Account.find_by_id(params[:id])
    if params[:account][:encrypted_credit_card].include?("XXXXXXX") && params[:account][:encrypted_credit_card].include?(account.last_four)
      params[:account][:encrypted_credit_card] = account.encrypted_credit_card
    end
    account.update(account_params)
    if account.invalid?
      setup_errors(account)
      redirect_to edit_account_path(account, user_id: params[:user_id])
    else
      flash[:notice] = "Success"
      account.save!
      redirect_to user_path(params[:user_id])
    end
  end
  
  def create
    @account = Account.new(account_params)
    @account.user_id = params[:user_id]
    if @account.save
      flash[:notice] = "Account Created"
      redirect_to user_path(params[:user_id])
    else
      flash[:alert] = "Invalid data"
      redirect_to new_account_path(params[:user_id])
    end
  end
  
  private
  def account_params
    params.require(:account).permit(:encrypted_credit_card, :name)
  end
end
