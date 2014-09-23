class Season < ActiveRecord::Base
  belongs_to :organization
  has_many :productions, :dependent => :destroy
  
  validates :year, presence: true
end
