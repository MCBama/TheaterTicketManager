class AddTheaterToProductions < ActiveRecord::Migration
  def change
    add_column :productions, :theater_id, :integer
  end
end
