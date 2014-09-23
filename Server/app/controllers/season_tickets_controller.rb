class SeasonTicketsController < ApplicationController
  include ApplicationHelper
  
  def new
    @organization_list = Organization.all

  end
  
  def index
    @organization = Organization.find_by_id(params[:organization_id])
    if @current_user.administrator?(@organization)
      @season_ticket_list = @organization.season_tickets
      respond_to do |format|
        format.html
        format.csv { send_data @season_ticket_list.to_csv }
      end
    else
      no_access_error
      redirect_to root_path
    end
  end
  
  def import
    @organization = Organization.find_by_id(params[:organization_id])
    SeasonTicket.import(params[:file])
    flash[:notice] = "Imported List"
    if @organization
      redirect_to season_tickets_path(organization_id: @organization)
    else
      raise "error"
    end
    
  end
  
  def show
    if(params[:calling_path] == "new_season_ticket")
      redirect_to :create, params
    else
      @season_ticket = SeasonTicket.find_by_id(params[:id])
      if @current_user.owner_of?(@season_ticket) or @current_user.administrator?(@season_ticket.organization)
        @user = @season_ticket.user
        @production_list = @season_ticket.organization.current_productions
        already_reserved_productions = @user.reserved_productions
        @production_list = @production_list.find_all{|p| !already_reserved_productions.include?(p.id)}
        
        gon.production_list = @production_list
        gon.performance_list = Performance.current_performances()
      else
        flash[:error]="That's not yours!"
        redirect_to root_path
      end
    end
  end
  
  def pick_seats
    if(params[:organization_id] and params[:user_id])
      @organization = Organization.find_by_id(params[:organization_id])
      @user = User.find_by_id(params[:user_id])
      if(@user)
        @theater = Theater.find_by_name("Concert Hall")
        @seat_list_concerthall = Array.new
        @theater.divisions.each do |division|
          division.seats.each do |seat|
            @seat_list_concerthall << seat
          end
        end
        
        @theater = Theater.find_by_name("Playhouse")
        @seat_list_playhouse = Array.new
        @theater.divisions.each do |division|
          division.seats.each do |seat|
            @seat_list_playhouse << seat
          end
        end
        
        @reserved_seats_concerthall = Array.new
        @reserved_seats_playhouse = Array.new
        @num_seats = params[:adult_stock].to_i
        @season_ticket_list = SeasonTicket.all.find_all{|st| st.organization == @organization}
        @season_ticket_list.each do |season_ticket|
          season_ticket.seats.each do |seat|
            
            if(seat.theater.name == "Concert Hall")
              @reserved_seats_concerthall << seat
            else
              @reserved_seats_playhouse << seat
            end
          end
        end
        
        gon.seat_list_concerthall = @seat_list_concerthall
        gon.seat_list_playhouse = @seat_list_playhouse
        gon.reserved_seats_concerthall = @reserved_seats_concerthall
        gon.reserved_seats_playhouse = @reserved_seats_playhouse
        gon.selected_seat = "seasonSeat"
        gon.season_seats = @num_seats
        gon.user_id = @user.id
        gon.organization_id = @organization.id
      else
        transaction_timed_out
        redirect_to root_path
      end
    else
      @transaction = Transaction.create
    end
  end
  
  def pick_performances
    user = User.find_by_id(params[:user_id])
    season_ticket = SeasonTicket.find_by_id(params[:id])
    
    ActiveRecord::Base.transaction do
      params[:performances].each do |k, v|
        performance = Performance.find_by_id(v)
        seats_list = season_ticket.seats.find_all{|s| s.theater.id == performance.theater.id}
        transaction = Transaction.new(pending: false, customer_name: user.name, performance: performance, encrypted_credit_card: user.encrypted_credit_card)
        if transaction.save
          seats_list.each do |seat|          
            ticket = Ticket.new(seat: seat, performance: performance, user: user, transaction: transaction, seat_type: "adult")
            if ticket.save
              flash[:notice] = "Your Reservations have been saved"
              transaction.tickets << ticket
            else
              setup_errors(ticket)
              raise ActiveRecord::Rollback
            end
          end
        else
          setup_errors(transaction)
          raise ActiveRecord::Rollback
        end
      end
    end    
    redirect_to user_path(user)
  end
  
  def reserve_seats
    @season_ticket = SeasonTicket.new(organization_id: params[:organization_id], user_id: params[:user_id])
    params[:seats].each do |key, value|
      @season_ticket.seats << Seat.find_by_id(key)
    end
    if @season_ticket.save
      flash[:notice] = "Thank you for your purchase"
      redirect_to season_ticket_path(id: @season_ticket.id)
    else
      setup_errors(@season_ticket)
      redirect_to root_path()
    end
    
  end
  
  def edit
    @season_ticket_holder = SeasonTicket.find_by_id(params[:id])
    @ticket_list = @season_ticket_holder.user.tickets
  end
  
  def destroy
    ticket = SeasonTicket.find_by_id(params[:id])
    ticket.destroy
    redirect_to season_tickets_path(params)
  end
  
end
