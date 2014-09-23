require 'bcrypt'

class Organization < ActiveRecord::Base
	has_many :productions
  has_many :users, :dependent => :destroy
	has_many :seasons, :dependent => :destroy
  has_many :supervisors, :dependent => :destroy
  has_many :season_tickets, :dependent => :destroy
  
  validates :name, :uniqueness => true, :length => { maximum: 30 }
  
  after_save :update_production_defaults
  
  def current_season
    seasons.find_by(:current => true)
  end
  
  def formatted_price(type) 
    if type.downcase == "adult" and default_adult
      return "%.2f" % default_adult
    elsif type.downcase == "child" and default_child
      return "%.2f" % default_child
    elsif type.downcase == "military" and default_military
      return "%.2f" % default_military
    end
  end
  
  def transaction_list
    Transaction.all.where(pending: false).find_all{|t| t.organization.id == self.id}
  end
  
  def current_productions
    if(current_season)
      current_season.productions
    else
      return []
    end
  end
  
  def has_supervisor?(code)
    supervisors.match(code)
  end
  
  def update_production_defaults
    productions.each {|p|p.update_default_prices}
  end
  
end
