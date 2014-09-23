class CreateDivision < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.belongs_to :theater
    end
  end
end
