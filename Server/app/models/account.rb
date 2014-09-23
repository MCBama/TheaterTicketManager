class Account < ActiveRecord::Base

  
  crypt_keeper :encrypted_credit_card, :encryptor => :aes, :key => 'public_key', salt: (0...8).map { (65 + rand(26)).chr }.join
  
  validate :name, :presence => true
  validate :encrypted_credit_card, :presence => true
  validates :encrypted_credit_card, length: { is: 16 }, numericality: { only_integer: true }
  
  belongs_to :user
  
  def last_four
    encrypted_credit_card[-4..-1]
  end
  
end
