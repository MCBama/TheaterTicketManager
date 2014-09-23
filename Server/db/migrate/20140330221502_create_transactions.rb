class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :ticket_id
      t.timestamps
    end
  end
end
