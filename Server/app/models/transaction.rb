class Transaction < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :performance
  has_many :tickets, dependent: :destroy
  
  crypt_keeper :encrypted_credit_card, :encryptor => :aes, :key => 'public_key', salt: (0...8).map { (65 + rand(26)).chr }.join
    
  validates_length_of :encrypted_credit_card, is: 16, unless: "encrypted_credit_card.nil?"
  validates :performance, presence: true
  
  delegate :production, to: :performance
  delegate :theater, to: :production
  delegate :organization, to: :performance
  
  after_save :payment_status
  
  
  def last_four
    "XXXXXXXXXXXX#{encrypted_credit_card[-4..-1]}"
  end

  def seat_types
    adult_seats = Array.new
    child_seats = Array.new
    military_seats = Array.new
    
    tickets.each do |ticket|
      case ticket.seat_type
        when "adult"
          adult_seats << ticket
        when "child"
          child_seats << ticket
        when "military"
          military_seats << ticket
      end
    end
    seat_list = {}
    seat_list["adult_seats"] = adult_seats
    seat_list["child_seats"] =  child_seats
    seat_list["military_seats"] = military_seats
    return seat_list
  end
  
  def update_seats(params)   
    success = true
    updated_seats = Array.new
    updated_seats << params[:adultSeats]
    updated_seats << params[:childSeats]
    updated_seats << params[:militarySeats]
    
    seat_hash = {}
    updated_seats.each do |a|
      seat_hash = seat_hash.merge(a)
    end
    
    seat_ids = Array.new    
    updated_seats.each do |hash|
      if hash
        hash.each do |key, value|
          seat_ids << key.to_i
        end
      end
    end

    ticket_list = {}
    ticket_seat_ids = Array.new
    tickets.each do |t|
      ticket_seat_ids << t.seat.id
      unless seat_ids.include?(t.seat.id)
        ticket_list[t.id]= t.seat_type 
      end
    end
    
    ActiveRecord::Base.transaction do
      updated_seats.each do |seat|
        if seat
          seat.each do |id, seat_type|
            seat = Seat.find_by_id(id)
            if ticket_list.count > 0 && ticket_list.has_value?(seat_type)
              ticket_id = ticket_list.rassoc(seat_type).first
            else
              break
            end
            ticket = tickets.find_by_id(ticket_id)
            puts ticket_seat_ids.include?(seat.id)
            unless ticket_seat_ids.include?(seat.id)
              ticket.update(seat: seat, transaction:self, performance: self.performance, seat_type: seat_type)
              ticket_list.delete(ticket.id)              
            end
            
            unless ticket.save
              ticket.save!
              success = false
              raise ActiveRecord::Rollback              
            end
          end
        elsif ticket_list.count <=0
          break
        end
      end
    end
    return success
  end

  def total_cost
    unless self.total
      set_total
    end
    return self.total
  end

  def set_total
    total_temp = 0.0
    tickets.each do |ticket|
      total_temp= total_temp + ticket.price
    end
    self.total = total_temp
    self.save!
  end
  
  def payment_status
    if self.encrypted_credit_card && !self.paid
      self.paid = true
      self.save!
    end
    return paid
  end

end
