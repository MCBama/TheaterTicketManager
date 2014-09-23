class AddDateToProduction < ActiveRecord::Migration
  def change
    add_column :productions, :start_date, :date
  end
end
