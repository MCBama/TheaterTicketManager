class Theater < ActiveRecord::Base

  has_many :divisions
  
  
  def set_theater_to_concert_hall
    self.name = "Concert Hall"
    divisions.all.each do |division|
      division.destroy
    end
    divisions << Division.create(theater: self, name: "Pit")
    divisions << Division.create(theater: self, name: "Loge")
    divisions << Division.create(theater: self, name: "Balcony")
    divisions.all.each do |division|
      division.set_concert_hall_division
    end
    self.save!
  end
  
  def set_theater_to_playhouse
    self.name = "Playhouse"
    divisions.all.each do |division|
      division.destroy
    end
    
    divisions<<Division.create(theater: self, name: "1")
    divisions<<Division.create(theater: self, name: "2")
    divisions<<Division.create(theater: self, name: "3")
    divisions<<Division.create(theater: self, name: "4")
    divisions<<Division.create(theater: self, name: "Loge 1")
    divisions<<Division.create(theater: self, name: "Loge 2")
    divisions<<Division.create(theater: self, name: "Loge 3")
    divisions<<Division.create(theater: self, name: "Loge 4")
    
    divisions.all.each do |division|
      division.set_playhouse_division
    end
    self.save!
  end
  
  def seat_list
    seat_list = Array.new
    divisions.each do |division|
      division.seats.each do |seat|
        seat_list << seat
      end
    end
    return seat_list
  end
  
end