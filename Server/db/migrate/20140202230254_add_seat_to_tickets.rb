class AddSeatToTickets < ActiveRecord::Migration
  def change
	add_column :tickets, :row, :string
	add_column :tickets, :seat_number, :integer
  end
end
