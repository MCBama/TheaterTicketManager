class AddInformationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :information, :string
  end
end
