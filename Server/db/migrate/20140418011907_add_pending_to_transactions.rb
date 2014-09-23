class AddPendingToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :pending, :boolean
  end
end
