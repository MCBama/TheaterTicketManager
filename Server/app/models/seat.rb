class Seat < ActiveRecord::Base
  belongs_to :division
  
  delegate :theater, to: :division
  has_and_belongs_to_many :season_tickets
  
  def seat_designation
    "#{division.name} #{row}-#{seat_number}"
  end
end
