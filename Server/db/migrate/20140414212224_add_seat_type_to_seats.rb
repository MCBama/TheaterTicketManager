class AddSeatTypeToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :seat_type, :string
  end
end
