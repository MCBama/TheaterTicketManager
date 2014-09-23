class CreateSeasonTickets < ActiveRecord::Migration
  def change
    create_table :season_tickets do |t|
      t.integer :user_id
      t.integer :organization_id
      t.integer :seat_id
      
      t.timestamps
    end
  end
end
