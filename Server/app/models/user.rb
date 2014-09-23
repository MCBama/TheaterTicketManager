class User < ActiveRecord::Base
  attr_accessor :password
 
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  AlphaNumeric_REGEX = /[^A-Z0-9@\.]|[\s]/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..30 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true #password_confirmation attr
  validates :password_confirmation, :presence=>true
  validates_length_of :password, :in => 6..20, :on => :create
  
  crypt_keeper :encrypted_credit_card, :encryptor => :aes, :key => 'public_key', salt: (0...8).map { (65 + rand(26)).chr }.join
  
  validates :account_level, inclusion: { in: %w(SysAdmin OrgAdmin Teller SeasonTicketHolder User) }
  validates :encrypted_credit_card, length: { is: 16 }, numericality: { only_integer: true }, unless: "encrypted_credit_card.nil?"
  validates :name, presence: true, if: "account_level == User"
  validates :street_address, presence: true, if: "account_level == 'User'"
  validates :city, presence: true, if: "account_level == 'User'"
  validates :state, presence: true, if: "account_level == 'User'"
  
  before_validation :standardize_inputs
  
  before_save :encrypt_password
  after_save :clear_password
  
  belongs_to :organization
  has_one :account
  has_many :season_tickets
  has_many :tickets
  
  def initialize(attributes={})
    super
    self.account_level ||= "User"
  end
  
   def last_four
    encrypted_credit_card[-4..-1]
  end
  
  def self.csv_column_names
    column_names    
  end
  
   def self.to_csv(organization)
     user_list = User.where(organization: organization)
     CSV.generate do |csv|

       user_list.each do |user|
       csv << user.attributes.values_at(*column_names)
      end
    end
  end
  
  def standardize_inputs
    self.username.upcase!
    self.email.upcase!
    self.email.gsub!(AlphaNumeric_REGEX, "")
  end
  
  def administrator?(organization=nil, supervisor_code=nil)
    if(organization && self.organization)
      @organization_id = organization.id
      if supervisor_code
        puts "**********************"
        puts organization.has_supervisor?(supervisor_code)
        puts "**********************"
        return organization.has_supervisor?(supervisor_code)
      else
        return (account_level == "SysAdmin") || (account_level =="OrgAdmin" && self.organization.id == @organization_id )
      end
    else
      return (account_level == "SysAdmin")
    end
  end
  
  def teller?(organization)
    if organization
      return account_level == "Teller" && self.organization.id == organization.id
    end
    return false
  end
  
  def owner_of?(model)
    self == model.user or self.administrator?
  end
  
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end
  
  def clear_password
    self.password = nil
  end
  
  def self.authenticate(username_or_email="", login_password="")
    if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end
    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end
  
  def match_password(login_password="")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end
  
  def self.generic_user
    User.new(username: "generic", email: "generic@email.com", password: "generic")
  end
  
  def reserved_productions(organization=nil)
    productions = {}
    ticket_list = self.current_tickets
    ticket_list.each do |ticket|
      productions[ticket.production.id] = ticket.production
    end
    if organization
      productions.each do |id, production|
        unless production.organization.id == organization.id
          productions.delete(id)
        end
      end
    end
    return productions
  end
  
  def current_tickets
    tickets.includes(:performance).find_all{|t| t.current == true if t }
  end
  
  def has_payment_information?
    self.name && self.encrypted_credit_card && self.street_address && self.city && self.state
  end
  
end
