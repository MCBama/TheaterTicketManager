class AddPerformanceDateToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :performance_start_date, :date
	add_column :performances, :performance_end_date, :date
	add_column :performances, :start_time, :time
	add_column :performances, :end_time, :time
	
  end
end
