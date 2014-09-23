class RemovePasswordFromOrganization < ActiveRecord::Migration
  def change
    remove_column :organizations, :password
    remove_column :organizations, :username
  end
end
