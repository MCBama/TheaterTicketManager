class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.string :name
      t.time :performance_time
      t.string :description
      
      t.timestamps
    end
  end
end
