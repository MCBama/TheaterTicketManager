class AddDivisionIdToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :division_id, :integer
  end
end
