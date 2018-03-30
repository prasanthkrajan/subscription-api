class User < ActiveRecord::Base
  has_one :subscription

  def account_type_premium?
    account_type == AccountType::PREMIUM
  end
end

