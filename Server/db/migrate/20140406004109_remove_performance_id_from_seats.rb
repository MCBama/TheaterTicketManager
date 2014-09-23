class RemovePerformanceIdFromSeats < ActiveRecord::Migration
  def change
    remove_column :seats, :performance_id
  end
end
