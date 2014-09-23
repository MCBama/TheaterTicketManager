class AddRowAndSeatNumberToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :row, :string
    add_column :seats, :seat_number, :integer
  end
end
