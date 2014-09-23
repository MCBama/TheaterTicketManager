class CreateSeasonTicketsSeats < ActiveRecord::Migration
  def change
    create_table :season_tickets_seats, id: false do |t|
      t.integer :season_ticket_id
      t.integer :seat_id
    end
  end
end
