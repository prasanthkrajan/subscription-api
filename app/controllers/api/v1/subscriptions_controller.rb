class Api::V1::SubscriptionsController < API::BaseController
  def callback
    return missing_params_error('status') unless params[:status].present?
    return invalid_params_error('status') if SubscriptionStatus::LISTED_STATUSES.exclude?(params[:status])
    case params[:status]
    when SubscriptionStatus::BILLED
      redirect_to update_subscription_path
    when SubscriptionStatus::TRIAL 
      redirect_to trial_subscription_path
    when SubscriptionStatus::CANCELLED 
      redirect_to cancel_subscription_path
    end
  end

  def update
  end

  def trial
  end

  def cancel
  end

  private

  def missing_params_error(param_name)
    render json: {status: 'error',message: "#{param_name} missing"}, status: 422
  end

  def invalid_params_error(param_name)
    render json: {status: 'error',message: "#{param_name} invalid"}, status: 422
  end
end