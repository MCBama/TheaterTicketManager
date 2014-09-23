module TicketsHelper
  
  def seat_list
    puts "****************************"
    puts File.read(Rails.root.join('app/assets/applet/SeatLocations.txt'))
    puts "****************************"
  end 
  
end
