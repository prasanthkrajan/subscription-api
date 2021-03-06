class Subscription < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :destroy


  def active?
    return false unless end_date.present?
    end_date.future? && status == SubscriptionStatus::ACTIVE
  end

  def cancelled?
    status == SubscriptionStatus::CANCELLED && user.account_type_free?
  end

  def trial?
    status == SubscriptionStatus::TRIAL && user.account_type_new?
  end

  def renew_billing(params)
    update_billing_cycle(params)
    set_user_account_to_premium unless user.account_type_premium?
    trigger_transaction_renew_callback(params)
  end

  def set_to_trial(params)
    update_subscription_to_trial(params)
    trigger_transaction_zero_amount_callback(params)
  end

  def cancel_subscription(params)
    update_subscription_to_cancel(params)
    set_user_account_to_free unless user.account_type_free?
    trigger_transaction_zero_amount_callback(params)
  end

  private

  def cycle_start_date
    Date.today
  end

  def cycle_end_date(plan_code)
    cycle_start_date + billing_period(plan_code)
  end

  def billing_period(plan_code)
    case plan_code
    when PlanType::DAILY
      1.DAILY
    when PlanType::WEEKLY
      1.week
    when PlanType::MONTHLY
      1.month
    end
  end

  def update_billing_cycle(params)
    self.update(start_date: cycle_start_date,
                end_date: cycle_end_date(params['plan_code']),
                plan_code: params['plan_code'],
                status: SubscriptionStatus::ACTIVE,
                next_billing_date: cycle_end_date(params['plan_code']) + 1.day)
  end

  def update_subscription_to_trial(params)
    self.update(start_date: cycle_start_date,
                end_date: cycle_end_date(params['plan_code']),
                plan_code: params['plan_code'],
                status: SubscriptionStatus::TRIAL)
  end

  def update_subscription_to_cancel(params)
    self.update(start_date: nil,
                end_date: nil,
                plan_code: nil,
                status: SubscriptionStatus::CANCELLED,
                next_billing_date: nil)
  end

  module Callbacks
    def trigger_transaction_renew_callback(params)
      Transaction.create(subscription_id: self.id,
                         amount: params['amount'],
                         payment_provider: params['payment_provider'],
                         status: params['status'],
                         transaction_ref: params['transaction_id'])
    end

    def trigger_transaction_zero_amount_callback(params)
      Transaction.create(subscription_id: self.id,
                         amount: 0,
                         payment_provider: params['payment_provider'],
                         status: params['status'],
                         transaction_ref: params['transaction_id'])
    end
  end

  include Callbacks
  

  def set_user_account_to_premium
    user.update(account_type: AccountType::PREMIUM)
  end

  def set_user_account_to_free
    user.update(account_type: AccountType::FREE)
  end
end
