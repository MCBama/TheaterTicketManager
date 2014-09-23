class SetCreditCardToText < ActiveRecord::Migration
  def up
    change_column :accounts, :encrypted_credit_card, :text
  end
  
  def down
    change_column :accounts, :encrypted_credit_card, :string
  end
end
