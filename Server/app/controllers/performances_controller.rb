
class PerformancesController < ApplicationController
	
	def index
		@performance_list = Performance.all
		if(params[:performance_errors])
			puts "made it here at least"
			@errors = params[:performance_errors]
		end
	end
	
	def new
    @organization = Organization.find_by_id(params[:organization_id])
    if @current_user.administrator?(@organization)
      
    else
      flash[:error] = "You don't have access rights to that page"
      redirect_to root_path()
    end
	end
	
	def create
		@new_performance = Performance.create(name: params[:performance][:name], 
			description: params[:performance][:description],
			performance_start_date: Date.strptime(params[:performance][:start_date],"%m/%d/%Y"),
			performance_end_date: Date.strptime(params[:performance][:end_date], "%m/%d/%Y"),
			start_time: time_hash_to_time(params[:start_time]),
			end_time: time_hash_to_time(params[:end_time]),
      production_id: params[:production_id])
		if (@new_performance.valid?)
			redirect_to edit_production_path(params[:production_id])
		else
      flash[:error] = "Invalid Performance data. Try again."
			render action: 'new'
		end
	end
  
  def edit
    @performance = Performance.find_by_id(params[:id])
  end
  
  def update
    performance = Performance.find_by_id(params[:id])
    performance.update(performance_params)
    if params[:start_time]
      performance.start_time = time_hash_to_time(params[:start_time])
    end
    if params[:end_time]
      performance.end_time = time_hash_to_time(params[:end_time])
    end
    if params[:performance][:performance_start_date]
      performance.performance_start_date = Date.strptime(params[:performance][:performance_start_date],"%m/%d/%Y")
      date = performance.performance_start_date
      performance.start_time.change(year: date.year, month: date.month, day: date.day)
    end
    
    performance.save!
    
    if performance.valid?
      redirect_to edit_production_path(performance.production)
    else
      setup_errors(performance)
      redirect_to action: 'edit'
    end
    update_prices(params[:performance][:division_price_points_attributes])
  end
	
	def show
		@performance = Performance.find_by_id(params[:id])
    @theater = Theater.includes(divisions: :seats).find_by_id(@performance.theater.id)
    @production = @performance.production
    @tickets = Ticket.reserved_seats(@performance)
    @seat_list = Array.new
    @reserved_seat_list = Array.new
      
    @seat_list = @theater.seat_list()
    @not_transaction = true    
    @tickets.each do |ticket|
      @reserved_seat_list << ticket.seat
    end
    
    if @theater.name == "Concert Hall"
      gon.reserved_seats_concerthall = @reserved_seat_list
    elsif @theater.name == "Playhouse"
      gon.reserved_seats_playhouse = @reserved_seat_list
    end
    
    gon.theater = @theater.name.downcase.gsub(" ", "")    
    gon.seat_list = @seat_list
    gon.seat_selection_enabled = false
	end
  
  def destroy
    @performance = Performance.find_by_id(params[:id])
    production_id = @performance.production.id
    @performance.destroy
    redirect_to edit_production_path(production_id)
  end
  
  private
  def performance_params
    params.require(:performance).permit(:name, :description)
  end
  
  def price_params(params)
    params.require(:division_price_point).permit(:adult_price, :child_price, :miltary_price)
  end
  
  def update_prices(price_params)
    puts price_params["0"]
    price_params.each do |key, value|
      price_point = DivisionPricePoint.find_by_id(value[:id])
      price_point.adult_price = value[:adult_price]
      price_point.child_price = value[:child_price]
      price_point.military_price = value[:military_price]
      price_point.save!
    end
  end
end
