require 'open-uri'
require 'uri'

class Division < ActiveRecord::Base
  
  belongs_to :theater
  has_many :concert_hall_performance_prices
  has_many :seats
  
  def set_concert_hall_division
  
    seats.each do |seat|
      seat.destroy
    end
    
    File.open("public/concerthall-seat-locations.txt") do |file|
      while( string = file.gets)
        string = string.split(',') if string
        y_offset = 14
        if string[0].to_i == 0
          if self.name == "Pit"
            if string[1] < 'F'
              seats << Seat.create(division: self, row: string[1], seat_number: string[2].to_i, pixel_x: string[3].to_i, pixel_y: string[4].to_i + y_offset)
            else
              break
            end
          elsif self.name == "Loge"
            if (string[1]>='F') and (string[1] <= 'Z')
              seats << Seat.create(division: self, row: string[1], seat_number: string[2].to_i, pixel_x: string[3].to_i, pixel_y: string[4].to_i + y_offset)
            end
          end
        else
          if self.name == "Balcony"
            seats << Seat.create(division: self, row: string[1], seat_number: string[2].to_i, pixel_x: string[3].to_i, pixel_y: string[4].to_i + y_offset)
          end
        end
      end
    end
    
  end
  
  def set_playhouse_division
    seats.each do |seat|
      seat.destroy
    end
    x_offset = 5
    y_offset = 25
    File.open("public/playhouse-seat-locations.txt") do |file|
      while( string = file.gets)
        string = string.split(',') if string
        if self.name.upcase == string[0].upcase || self.name.upcase == "LOGE #{string[0].upcase.to_i - 4}"
          seats << Seat.create!(division: self, row: string[1], seat_number: string[2].to_i, pixel_x: string[4].to_i + x_offset, pixel_y: string[3].to_i + y_offset)
        end
        
      end
    end
  end
end
