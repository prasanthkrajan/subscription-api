class Api::V1::SubscriptionsController < API::BaseController

  before_action :params_prerequisite_check, only: :callback

  def callback
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

  def params_prerequisite_check
    @expected_params = CustomErrorHandler::ParamValidation.new(params)
    return missing_param_error(@expected_params.missing_param) if @expected_params.missing?
    return invalid_param_error(@expected_params.invalid_param) if @expected_params.invalid?
  end

  def missing_param_error(param)
    render json: CustomErrorHandler::ErrorMessage.missing_param_error(param), status: 422
  end

  def invalid_param_error(param)
    render json: CustomErrorHandler::ErrorMessage.invalid_param_error(param), status: 422
  end
end