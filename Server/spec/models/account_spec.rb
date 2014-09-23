require 'spec_helper'

describe Account do
  before(:all) do
    @account = Account.create(name: "Bob", credit_card: "1234567890A1")
  end
  it 'encrypts credit card information' do
    expect(@account.encrypted_credit_card).not_to equal("123456789A1")
  end
  
  it 'clears old card information' do
    expect(@account.credit_card).to be_nil
  end
end
