class Ticket < ActiveRecord::Base
	belongs_to :performance
	belongs_to :seat
  belongs_to :transaction
  belongs_to :user
  
  validates :performance, :presence => true
  validates :transaction, :presence => true
  validates_uniqueness_of :seat_id, :scope => :performance_id
  validates :seat_type, presence: true
  validates :seat, presence: true
  
  delegate :production, to: :performance
  delegate :organization, to: :performance
  delegate :theater, to: :production
  delegate :row, to: :seat
  delegate :seat_number, to: :seat
  delegate :current, to: :performance
  
  scope :performance_reserved_seats, ->(performance_id) { where("performance_id = ?", performance_id) }
  
  def price
    
    price_point = performance.division_price_points.find_by_division_id(seat.division)
    
    if seat_type == "adult"
      return price_point.adult_price
    elsif seat_type == "child"
      return price_point.child_price
    elsif seat_type == "military"
      return price_point.military_price
    else
      return "Price Not Set"
    end
  end
	
  def self.has_ticket_id?(id)
    all.each do |t|
      if t.id == id
        return true
      end
    end
    return false
  end
  
  def self.has_seat_id(id)
    all.each do |t|
      if t.seat.id == id
        return true
      end
    end
    return false
  end
  
  def self.reserved_seats(performance)
    includes(:seat).joins(:seat=>:division).where(:divisions => {:theater_id => performance.theater.id}).find_all{|t| t.performance_id == performance.id}
  end
  
end
