class AddTransactionsToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :transaction_id, :integer
    add_column :transactions, :performance_id, :integer
  end
end
