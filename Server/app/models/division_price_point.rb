class DivisionPricePoint < ActiveRecord::Base
  belongs_to :performance
  belongs_to :division
  
  delegate :name, to: :division
  
end
