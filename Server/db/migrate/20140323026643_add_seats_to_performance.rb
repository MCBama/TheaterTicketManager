class AddSeatsToPerformance < ActiveRecord::Migration
  def change
    add_column :seats, :performance_id, :integer
  end
end
