class Api::V1::SubscriptionsController < API::BaseController
  def callback
    params_validation_passed?('status')
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
    params_prerequisite_check('amount','payment_provider','plan_code')
  end

  def trial
  end

  def cancel
  end

  private

  def params_validation_passed?(*params)
    params.each do |param|
      param_missing?(param)
      param_invalid?(param)
    end
    true 
  end

  def missing_params_check(param)
    missing_params_error(param) unless param.present?
  end

  def invalid_params_check(param)
    invalid_params_error(params) if CustomErrorHandler::InvalidParam.params_confirmed_invalid?(param)
  end

  def missing_params_error(param)
    render json: CustomErrorHandler::MissingParam.raise_error(param), status: 422
    return false
  end

  def invalid_params_error(param)
    render json: CustomErrorHandler::InvalidParam.raise_error(param), status: 422
    return false
  end
end