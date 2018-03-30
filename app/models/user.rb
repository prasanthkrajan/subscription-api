class User < ActiveRecord::Base
  has_one :subscription, dependent: :destroy

  def account_type_premium?
    account_type == AccountType::PREMIUM
  end

  def account_type_free?
    account_type == AccountType::FREE
  end

  def account_type_new?
    account_type == AccountType::NEW
  end
end

