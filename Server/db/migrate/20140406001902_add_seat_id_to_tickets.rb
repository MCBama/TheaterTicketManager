class AddSeatIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :seat_id, :integer
    add_column :tickets, :performance_id, :integer
    remove_column :tickets, :row
    remove_column :tickets, :seat_number
  end
end
