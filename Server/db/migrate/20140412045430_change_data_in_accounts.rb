class ChangeDataInAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :username, :string
    remove_column :accounts, :password, :string
    add_column :accounts, :name, :string
    add_column :accounts, :encrypted_credit_card, :string
    add_column :accounts, :salt, :string
    add_column :accounts, :user_id, :integer
    add_column :accounts, :last_four, :string
  end
end
