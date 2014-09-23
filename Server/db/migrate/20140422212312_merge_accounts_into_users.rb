class MergeAccountsIntoUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :card_salt, :string
    add_column :users, :last_four, :string
    add_column :users, :encrypted_credit_card, :text
  end
end
