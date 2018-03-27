class Transaction < ActiveRecord::Base
  belongs_to :subscription
end
