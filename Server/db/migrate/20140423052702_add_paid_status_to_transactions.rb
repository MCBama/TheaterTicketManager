class AddPaidStatusToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :pay_at_door, :boolean
    add_column :transactions, :paid, :boolean
  end
end
