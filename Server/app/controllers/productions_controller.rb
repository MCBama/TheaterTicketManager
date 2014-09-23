class ProductionsController < ApplicationController

  def index
    @production_list = Production.includes(:season).where("seasons.current" => true).order(:start_date)
  end
  
  def new
    @production = Production.new
    @organization = Organization.find_by_id(params[:organization_id])
    @organization_list = Organization.all.map { |org| [org.name, org.id] }
    @theater_list = Theater.all.map { |theater| [theater.name, theater.id] }
  end
  
  def update
    production = Production.find_by_id(params[:id])
    production.update(production_params)
    if production.invalid?
      setup_errors(production)
    end
    redirect_to edit_production_path(params[:id])
  end
  
  def create
    @organization = Organization.find_by_id(params[:organization_id])
    time = time_hash_to_time(params[:start_time])
    @theater = Theater.find_by_id(params[:theater_id])
    if @current_user.administrator?(@organization)      
      if @organization.current_season
        @production = Production.create(:title => params[:production][:title], 
          :organization_id => params[:organization_id], 
          :season_id => @organization.current_season.id,
          :start_date => Date.strptime(params[:production][:start_date], "%m/%d/%Y"),
          :theater_id => @theater.id )
        if @production.valid?
          @production.save!
          @production.performances.each do |performance|
            performance.start_time = time
            performance.end_time = time + 1.hour
            performance.save!
          end
          redirect_to edit_organization_path(@organization)
        else
          error_message = ""
          @production.errors.full_messages.each do |msg|
            error_message << "<p>#{msg}</p>"
          end
          flash[:error] = error_message.html_safe
          redirect_to edit_organization_path(@organization)
        end
      else
        flash[:error] = "Please create a season first"
        redirect_to edit_organization_path(@organization)
      end
    else
      flash[:error] = "You don't have rights to create that production"
      redirect_to root_path
    end
  end
  
  def show
    @production = Production.find_by_id(params[:id])
  end
  
  def edit
    @production = Production.find_by_id(params[:id])
    @performance_list = @production.performances.order(:performance_start_date)
  end
  
  def destroy
    @production = Production.find_by_id(params[:id])
    @organization_id = @production.organization.id
    @production.destroy
    redirect_to edit_organization_path(@organization_id)
  end
  
  private
  def production_params
    params.require(:production).permit(:organization_id, :title, :season_id, :start_date, :description, :theater_id)
  end
end
