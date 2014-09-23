class AddPixelLocationsToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :pixel_x, :integer
    add_column :seats, :pixel_y, :integer
  end
end
