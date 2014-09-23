class AddTotalToTickets < ActiveRecord::Migration
  def change
    add_column :transactions, :total, :decimal, precision: 30, scale: 2
  end
end
