class Performance < ActiveRecord::Base
	validates :name, :production_id, presence: true
	
  belongs_to :production
  has_many :seats
  has_many :transactions, dependent: :destroy
  has_many :division_price_points
  
  accepts_nested_attributes_for :division_price_points
  
  delegate :organization, to: :production
  delegate :default_adult, to: :production 
  delegate :default_child, to: :production 
  delegate :default_military, to: :production 
  delegate :theater, to: :production
  delegate :current, to: :production
  
  after_create :set_default_prices
  
  after_save :update_production
  before_save :update_times
  
  
	def get_start_time
		self.start_time.strftime('%l:%M %p')
	end
	
	def get_end_time
		self.end_time.strftime('%l:%M %p')
	end
  
  def update_production
    production.update_start_date
  end
  
  def set_default_prices
    self.default_adult ||= production.default_adult
    self.default_child ||= production.default_child
    self.default_military ||= production.default_military
    
    division_price_points.each { |price_point| price_point.destroy }
    theater.divisions.each do |division|
      self.division_price_points << DivisionPricePoint.create(adult_price: default_adult, child_price: default_child, military_price: default_military, division: division)
    end
    self.save!
  end
  
  def reset_default_prices
    self.default_adult = production.default_adult
    self.default_child = production.default_child
    self.default_military = production.default_military
    self.save!    
  end

  def reserved_seats
    reserved_seats = Array.new
  end
  
  def self.current_performances
    performance_list = Array.new
    production_list = Production.current_productions
    production_list.each do |production|
      if production.season.current
        production.performances.each do |performance|
          performance_list << performance if performance.upcoming?
        end
      end
    end
    performance_list
  end
  
  def self.todays_performances
    performance_list = Array.new
    production_list = Production.current_productions
    production_list.each do |production|
      if production.season.current
        production.performances.each do |performance|
          performance_list << performance if performance.performance_start_date == Date.today
        end
      end
    end
    performance_list    
  end
  
  def update_times
    date = performance_start_date
    self.start_time = self.start_time.change(year: date.year, month: date.month, day: date.day)
  end
  
  def upcoming?
    date = performance_start_date
    date > Time.zone.now.to_date || (!start_time.past?)
  end
  
end
