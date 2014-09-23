class OrganizationsController < ApplicationController
  before_filter :set_organization_list
	
	def index
		
	end
  
  def show

  end
  
	def create
    if(@current_user.administrator?)
      puts params[:organization][:name]
        ActiveRecord::Base.transaction do
          org = Organization.new(name: params[:organization][:name])
          if org.invalid?
            setup_errors(org)
            redirect_to action: 'index' and return
          end
          org.save!
          @username = params[:organization][:name]
          @username.gsub!(" ", "")
          @username = @username[0,10]
          user = User.new(username: "#{@username}_admin", 
                      password: "123456", password_confirmation: "123456", account_level: "OrgAdmin", email: "#{params[:organization][:name]}_admin@admin.net",
          organization: org)
          user.save!
          teller = User.new(username: "#{@username}_teller",
            password: "123456", password_confirmation: "123456", email: "#{params[:organization][:name]}_teller@teller.net",
            account_level: "Teller", organization: org)
          teller.save!
        
          flash[:notice]= "Successfully created #{params[:organization][:name]}
          <ul>
            <li>Admin Account: #{@username}_admin</li>
            <li>Teller Account: #{@username}_teller</li>
          </ul>".html_safe
        end
        redirect_to action: 'index'
    else
      flash[:error] = "You don't have rights to create a new organization"
      redirect_to root_path
    end
	end
  
	def destroy
		@organization = Organization.find_by_id(params[:id])
		@organization.destroy
    if params[:call_location] == "admin_control"
      redirect_to admin_control_path
    else
      redirect_to action: params[:call_location] 
    end
	end
	
  def edit
    @organization = Organization.find_by_id(params[:id])
    if authenticate_admin(@organization)
      @supervisor_list = @organization.supervisors
    end
    
  end
  
  def show
    @organization = Organization.find_by_id(params[:id])
  end
  
  def update
    organization = Organization.find_by_id(params[:id])
    organization.update(organization_params)
    if organization.invalid?
      setup_errors(organization)
      redirect_to edit_organization_path(organization)
    else
      flash[:notice]="Successfully updated organization"
      redirect_to edit_organization_path(params[:id])
    end
  end
	
	
private
	def set_organization_list
		@organization_list = Organization.all
	end
  
  def organization_params
    params.require(:organization).permit(:name, :default_adult, :default_child, :default_military, :default_season, :information)
  end
end
