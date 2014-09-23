class AddNameToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :name, :string
  end
end
