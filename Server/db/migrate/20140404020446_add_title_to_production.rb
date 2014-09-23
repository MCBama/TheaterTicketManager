class AddTitleToProduction < ActiveRecord::Migration
  def change
    add_column :productions, :title, :string
  end
end
