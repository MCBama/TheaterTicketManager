class Supervisor < ActiveRecord::Base
  belongs_to :organization
  validates :name, presence: true
  validates :code, presence: true, length: { is: 4 }
  validates_uniqueness_of :code, message: "has already been assigned", scope: :organization_id
  
  def self.match code
    all.each do |s|
      if s.code == code
        return true
      end
    end
    return false
  end
  
end
