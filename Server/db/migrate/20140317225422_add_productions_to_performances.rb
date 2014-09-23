class AddProductionsToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :production_id, :integer
  end
end
