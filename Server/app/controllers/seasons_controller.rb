class SeasonsController < ApplicationController
  
  def new
    @organization = Organization.find_by_id(params[:organization_id])
    current_season = @organization.current_season
    @organization.seasons.all.each do |season|
      season.update(:current => false)
    end
    season = Season.create(:year => Time.now.year, :organization => @organization, :current => true)
    
    redirect_to edit_organization_path(@organization)
  end
  
  def show
    @season = Season.find_by_id(params[:id])
  end
  
  def destroy
    season = Season.find_by_id(params[:id])
    season.destroy
    redirect_to edit_organization_path(params[:organization_id])
  end
  
  def update
    @season = Season.find_by_id(params[:id])
    @organization = @season.organization
    @organization.current_season.update(current: false)
    @season.update(current: true)
    unless @season.save
      setup_errors(@season)
    else
      flash[:notice] = "Success"
    end
    redirect_to edit_organization_path(params[:organization_id])
  end
  
end
