class TicketsController < ApplicationController

  def index
    @user = User.find_by_id(params[:user_id])
    @season_ticket = SeasonTicket.find_by_id(params[:season_ticket_id])
  end
  
  def create
	
  end
  
  def new
    unless(params[:transaction_id] != "")
      @performance = Performance.find_by_id(params[:performance_id])
      @transaction = Transaction.create(performance: @performance, pending: true)
      @transaction.save!
    else
      @transaction = Transaction.find_by_id(params[:transaction_id])
      @performance = Performance.find_by_id(params[:performance_id])
    end
    
    if(@performance.upcoming?)
      if(@transaction)
        @theater = @performance.theater
        @seat_list = Array.new
        @theater.divisions.each do |division|
          division.seats.each do |seat|
            @seat_list << seat
          end
        end
        @reserved_seats_concerthall = Array.new
        @reserved_seats_playhouse = Array.new
        @ticket_list = Ticket.performance_reserved_seats(@performance.id)
          if(@theater.name == "Concert Hall")
            @reserved_seats_concerthall = @ticket_list
          else
            @reserved_seats_playhouse = @ticket_list
          end
        #if(@theater.name == "Concert Hall")
        #  gon.theater = "concerthall"
        #else
        #  gon.theater = "playhouse"
        #end
        
        gon.theater = @theater.name.downcase.gsub(' ', "")
        
        @url = purchase_seats_transaction_path(@transaction.id)
        
        gon.seat_list = @seat_list
        gon.reserved_seats_concerthall = @reserved_seats_concerthall
        gon.reserved_seats_playhouse = @reserved_seats_playhouse
        gon.selected_seat = "adultSeat"
        gon.adult_seats = params[:adult_stock].to_i ||= 1
        gon.child_seats = params[:child_stock].to_i
        gon.military_seats = params[:military_stock].to_i
      else
        transaction_timed_out
        redirect_to root_path
      end
    else
      flash[:error]="That performance is no longer accepting new tickets"
      redirect_to root_path
    end
  end
  
  def new_season_ticket
    @organization_list = Organization.all
    @user = User.find_by_id(params[:user_id])
  end
  
  def edit
    @transaction = Transaction.find_by_id(params[:transaction_id])
    @seat_list = @ticket.theater.seat_list
    gon.seat_list = @seat_list
    
  end
  
  def update
    @transaction = Transaction.find_by_id(params[:transaction_id])
  end
end

