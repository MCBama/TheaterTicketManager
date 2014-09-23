class AddPaymentInfoToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :customer_name, :string
    add_column :transactions, :encrypted_credit_card, :text
  end
end
