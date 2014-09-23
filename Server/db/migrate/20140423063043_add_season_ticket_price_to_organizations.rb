class AddSeasonTicketPriceToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :default_season, :decimal, precision: 30, scale: 2
  end
end
