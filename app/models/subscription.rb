class Subscription < ActiveRecord::Base
  belongs_to :user
  has_many :transactions


  def still_active?
    return false unless end_date.present?
    end_date.future? && status == SubscriptionStatus::ACTIVE
  end

  def renew_billing(params)
    update_subscription_status(params)
    set_user_account_to_premium unless user.account_type_premium?
    trigger_renew_callback(params)
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

  def update_subscription_status(params)
    self.update(start_date: cycle_start_date,
                end_date: cycle_end_date(params['plan_code']),
                plan_code: params['plan_code'],
                status: PlanType::ACTIVE)
  end

  def trigger_renew_callback(params)
    Transaction.create(subscription_id: self.id,
                       amount: params['amount'],
                       payment_provider: params['payment_provider'],
                       status: params['status'],
                       transaction_ref: params['transaction_id'])
  end

  def set_user_account_to_premium
    user.update(account_type: AccountType::PREMIUM)
  end
end
