class AddTransactionToTickets < ActiveRecord::Migration
  def change
    add_reference :tickets, :transaction, index: true
  end
end
