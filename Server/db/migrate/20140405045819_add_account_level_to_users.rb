class AddAccountLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_level, :string
  end
end
