class AddUsernameAndPasswordToOrganizations < ActiveRecord::Migration
  def change
		add_column :organizations, :username, :string
		add_column :organizations, :password, :string
  end
end
