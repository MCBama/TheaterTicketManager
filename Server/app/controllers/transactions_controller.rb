class TransactionsController < ApplicationController
  include TransactionsHelper
  before_filter only: [:list, :destroy] { |c| c.establish_organization(params) } 
  before_action only: [:list, :destroy] { |c| (@current_user.teller?(@organization) || authenticate_admin(@organization, params[:supervisor_code])) }
  
  def purchase_seats
    clear_old_transactions
    transaction = Transaction.find_by_id(params[:id])
    success = true
    ActiveRecord::Base.transaction do
      if(transaction)
        ticket_list = Array.new
        if(params[:adultSeats])
          params[:adultSeats].each do |k, v|
            seat = Seat.find_by_id(k)
            ticket_list << Ticket.new(transaction: transaction, seat: seat, performance: transaction.performance, seat_type: v)
          end
        end
        if params[:childSeats]
          params[:childSeats].each do |k,v|
            seat = Seat.find_by_id(k)
            ticket_list << Ticket.new(transaction: transaction, seat: seat, performance: transaction.performance, seat_type: v)
          end
        end
        if params[:militarySeats]
          params[:militarySeats].each do |k,v|
            seat = Seat.find_by_id(k)
            ticket_list << Ticket.new(transaction: transaction, seat: seat, performance: transaction.performance, seat_type: v)
          end
        end
        ticket_list.each do |ticket|
          if ticket.save
            transaction.tickets << ticket
            if transaction.save
              
            else
              setup_errors(transaction)
              success = false
              raise ActiveRecord::Rollback
            end
          else
            setup_errors(ticket)
            success = false
            raise ActiveRecord::Rollback
          end
        end
      else
        flash[:error]= "Transaction Timed Out. Please try again."
        sucess = false
        redirect_to new_transaction_path()
      end
    end
    if success
      redirect_to transaction_payment_path(transaction)
    else
      redirect_to root_path()
    end
  end
  
  def pick_seat_numbers
    @number_array = 1..20
  end
  
  def list
    @transaction_list = @organization.transaction_list
  end
  
  def new
    clear_old_transactions
    @organization_list = Organization.all
    @production_list = Production.current_productions
    @performance_list = Performance.current_performances
    
    gon.organization_list = @organization_list
    gon.production_list = @production_list
    gon.performance_list = @performance_list
  end
  
  def create
  
    performance = Performance.find_by_id(params[:performance_id])
    transaction = Transaction.new(performance: performance, pending: true)
    transaction.save!
    
    redirect_to pick_seat_numbers_transactions_path(transaction_id: transaction, performance_id: performance.id)
  end

  def payment
    @transaction = Transaction.find_by_id(params[:transaction_id])
    if @current_user.account_level == "User"
      @user = @current_user
      @customer_name = @user.name
      @credit_card = @user.encrypted_credit_card
    end
  end
  
  def update
    @transaction = Transaction.find_by_id(params[:id])
    unless @transaction.update(payment_params)
      setup_errors(@transaction)
    else
      flash[:notice] = "Successfully updated transaction."
    end
    
    redirect_to edit_transaction_path(@transaction, organization_id: params[:organization_id])
      
  end
  
  def update_information
    clear_old_transactions
    transaction = Transaction.find_by_id(params[:transaction_id])
    if params[:transaction][:customer_name] != ""
      if(transaction)
        transaction.update(payment_params)
        if transaction.save
          redirect_to transaction_summary_page_path(transaction)
        else
          setup_errors(transaction)
          redirect_to root_path()
        end
      else
        flash[:error]= "Transaction Timed Out. Please try again."
        redirect_to new_transaction_path()
      end
    else
      flash[:error] = "Customer name can't be blank."
      redirect_to transaction_payment_path(id: params[:transaction_id])
    end
  end
  
  def update_payment
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.paid = true
    unless @transaction.save
      setup_errors(@transaction)
    else 
      flash[:notice] = "Updated payment successfully"
    end
    redirect_to list_transactions_path(organization_id: params[:organization_id])
  end
  
  def summary_page
    @transaction = Transaction.find_by_id(params[:transaction_id])
    @transaction.set_total
  end
  
  def confirm
    @transaction = Transaction.find_by_id(params[:transaction_id])
    @transaction.pending= false
    if @transaction.encrypted_credit_card || params[:paid_at_door]
      @transaction.paid = true
    else
      @transaction.paid = false
    end
    
    if @transaction.save
      flash[:notice] = "Thank you for your purchase!"
      redirect_to root_path()
    else
      setup_errors(@transaction)
      redirect_to root_path()
    end
  end
  
  def destroy
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.destroy
    redirect_to list_transactions_path(organization_id: params[:organization_id])
    flash[:notice] = "Ticket has been successfully deleted"
  end
  
  def establish_organization(params)
    @organization = Organization.find_by_id(params[:organization_id])
  end
  
  def edit
    @transaction = Transaction.find_by_id(params[:id])
    @performance = @transaction.performance
    @organization = @performance.organization
  end
  
  def swap_seats
    @transaction = Transaction.find_by_id(params[:id])
      if(@transaction)
        @performance = Performance.find_by_id(@transaction.performance.id)
        @theater = @performance.theater
        @seat_list = Array.new
        @theater.divisions.each do |division|
          division.seats.each do |seat|
            @seat_list << seat
          end
        end
        @reserved_seats_concerthall = Array.new
        @reserved_seats_playhouse = Array.new
        Ticket.all.find_all{|t| t.performance.id == @performance.id}.each do |ticket|
          if(@theater.name == "Concert Hall")
            @reserved_seats_concerthall << ticket
          else
            @reserved_seats_playhouse << ticket
          end
        end
        if(@theater.name == "Concert Hall")
          gon.theater = "concerthall"
        else
          gon.theater = "playhouse"
        end
        
        gon.seat_list = @seat_list
        gon.reserved_seats_concerthall = @reserved_seats_concerthall
        gon.reserved_seats_playhouse = @reserved_seats_playhouse
        gon.selected_seat = "adultSeat"
        gon.adult_seats = 0
        gon.child_seats = 0
        gon.military_seats = 0
        @transferable_seats = @transaction.seat_types
        gon.transferable_seats = @transferable_seats
        @url = change_seats_transaction_path(@transaction.id)
      else
        transaction_timed_out
        redirect_to root_path
      end
    
  end
  
  def change_seats
    @transaction = Transaction.find_by_id(params[:id])
    success = @transaction.update_seats(params)
    unless success
      setup_errors(@transaction)
    end
    redirect_to action: "edit"
  end
  
  def pick_performance
    @transaction = Transaction.find_by_id(params[:id])
    @performance_list = @transaction.production.performances
    @performance_options = @performance_list.map {|p| [p.name, p.id] }
  end
  
  def swap_performances
    @transaction = Transaction.find_by_id(params[:id])
    if(@transaction)
      @old_performance = @transaction.performance
      @new_performance = Performance.find_by_id(params[:performance_id])
      @transaction.performance = @new_performance
      @transaction.save!
      @theater = @new_performance.theater
      
      @seat_list = Array.new
      @reserved_seats_concerthall = Array.new
      @reserved_seats_playhouse = Array.new
      
      @theater.divisions.each do |division|
        division.seats.each do |seat|
          @seat_list << seat
        end
      end
      Ticket.all.find_all{|t| t.performance.id == @new_performance.id}.each do |ticket|
        if(@theater.name == "Concert Hall")
          @reserved_seats_concerthall << ticket
        else
          @reserved_seats_playhouse << ticket
        end
      end
      
      seat_types = @transaction.seat_types
      #@transaction.destroy
      if(@theater.name == "Concert Hall")
        gon.theater = "concerthall"
      else
        gon.theater = "playhouse"
      end
      
      gon.seat_list = @seat_list
      gon.reserved_seats_concerthall = @reserved_seats_concerthall
      gon.reserved_seats_playhouse = @reserved_seats_playhouse
      gon.selected_seat = "adultSeat"
      gon.adult_seats = seat_types["adult_seats"].count
      gon.child_seats = seat_types["child_seats"].count
      gon.military_seats = seat_types["military_seats"].count
      @url = change_seats_transaction_path(@transaction.id)
    else
      transaction_timed_out
      redirect_to root_path
    end
  end
  
private
  def payment_params
    params.require(:transaction).permit(:customer_name, :encrypted_credit_card, :pay_at_door, :total)
  end
  
end

