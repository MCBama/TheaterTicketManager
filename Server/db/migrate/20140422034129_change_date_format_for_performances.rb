class ChangeDateFormatForPerformances < ActiveRecord::Migration
  def change
    change_column :performances, :start_time, :datetime
    change_column :performances, :end_time, :datetime
  end
end
