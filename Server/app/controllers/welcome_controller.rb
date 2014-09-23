class WelcomeController < ApplicationController
  
  def new
    
  end
	
  def index
    @look_ahead = 3;
    
    @today_date = Time.zone.now.to_date
    @tomorrow_date = @today_date + 1
    @future_date = @tomorrow_date + @look_ahead
    @current_performance_list = Array.new
    @today_performance_list = Array.new
    @future_performance_list = Array.new
    
    @today_performance_list = Performance.todays_performances
      
    Performance.current_performances.each do |performance|
      if performance.performance_start_date >= @tomorrow_date && performance.performance_start_date <= @future_date
        @future_performance_list << performance
      end
    end
    
  end
  
end
