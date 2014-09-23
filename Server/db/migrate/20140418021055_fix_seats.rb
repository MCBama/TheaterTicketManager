class FixSeats < ActiveRecord::Migration
  def change
    remove_column :seats, :seat_type, :string

    add_column :tickets, :seat_type, :string
  end
end
