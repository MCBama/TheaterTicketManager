class AddDataToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :organization_id, :integer
    add_column :seasons, :year, :integer
    add_column :seasons, :current, :boolean
    add_column :productions, :season_id, :integer
  end
end
