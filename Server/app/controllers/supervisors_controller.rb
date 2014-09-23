class SupervisorsController < ApplicationController
  before_filter :set_organization
  before_filter -> { authenticate_admin(@organization) }, only: [:update, :edit]
  
  def index
    @supervisor_list = @organization.supervisors.all
  end
  
  def new
    
  end
  
  def create
    @supervisor = Supervisor.new(supervisor_params)
    @supervisor.organization_id = params[:organization_id]
    if @supervisor.save
      flash[:notice] = "Successfully created Supervisor #{@supervisor.name}"
      redirect_to edit_organization_path(params[:organization_id])
    else
      setup_errors(@supervisor)
      render :new
    end
  end
  
  def destroy
    supervisor = Supervisor.find_by_id(params[:id])
    supervisor.destroy
    redirect_to edit_organization_path(params[:organization_id])
  end
  
  def edit
    @supervisor = Supervisor.find_by_id(params[:id])
  end
  
  def update
    @supervisor = Supervisor.find_by_id(params[:id])
    @supervisor.update(supervisor_params)
    redirect_to supervisors_path(organization_id: @organization.id)
  end
  
  def override
    
  end
  
  def override_request
    unless @organization.has_supervisor?(params[:supervisor][:code].to_i)
      flash[:error] = "Invalid code #{params[:code]}."
      redirect_to root_path
    end
    @supervisor = Supervisor.find_by_code(params[:supervisor][:code])
  end
  
  private
  
  def supervisor_params
    params.require(:supervisor).permit(:name, :code, :organization_id)
  end
  
  def set_organization
    if params[:organization_id]
      @organization = Organization.find_by_id(params[:organization_id])  
    else
      raise "Error has occurred in Organization_id for supervisors"
    end
  end
  
end
