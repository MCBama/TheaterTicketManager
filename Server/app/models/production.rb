class Production < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :organization
  belongs_to :season
  belongs_to :theater
  
  has_many :performances, :dependent => :destroy
  
  after_create :set_defaults
  
  
  validates :organization, :presence => true
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :theater, :presence => true
  validates :season, presence: true
  
  delegate :current, to: :season
  delegate :default_adult, to: :organization
  delegate :default_child, to: :organization
  delegate :default_military, to: :organization
  
  def set_defaults
    self.theater ||= Theater.last
    self.default_adult ||= organization.default_adult
    self.default_child ||= organization.default_child
    self.default_military ||= organization.default_military
    self.save!
    performances.each{|p|p.destroy}
    for i in 0..2
      performances << Performance.create(:name => "Performance #{i}",
        :description => "Performance #{i} Description", :start_time => Time.zone.now, 
          :end_time =>Time.zone.now, :performance_start_date => self.start_date + i.days,
          default_adult: default_adult, default_child: default_child, default_military: default_military)
    end
  end
  
  def update_default_prices    
    performances.each{|p| p.set_default_prices}     
  end
  
  def reset_default_prices
    self.default_adult = organization.default_adult
    self.default_child = organization.default_child
    self.default_military = organization.default_military
    performances.each do |performance|
      performance.reset_default_prices
    end
    self.save!
  end
  
  def update_start_date
    performances = self.performances.order(:performance_start_date)
    self.update(start_date: performances.first.performance_start_date)
  end
  
  def self.current_productions
    production_list = Array.new
    Organization.all.each do |organization|
      organization.current_productions.each do |production|
        production_list << production
      end
    end
    return production_list
  end
  
end
