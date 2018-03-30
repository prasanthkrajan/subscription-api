class Api::V1::SubscriptionsController < API::BaseController

  before_action :params_prerequisite_check, only: :callback
  before_action :check_if_transaction_processed, only: :callback
  before_action :set_variables, except: :callback

  def callback
    case params[:status]
    when SubscriptionStatus::BILLED
      redirect_to update_subscription_path(params)
    when SubscriptionStatus::TRIAL 
      redirect_to trial_subscription_path(params)
    when SubscriptionStatus::CANCELLED 
      redirect_to cancel_subscription_path(params)
    end
  end

  def update
    check_if_previous_subscription_still_active
    @subscription.renew_billing(params)
  end

  def trial
  end

  def cancel
  end

  private

  module ErrorMessages
    def missing_param_error(param)
    render json: CustomErrorHandler::ErrorMessage.missing_param_error(param), status: 422
    end

    def invalid_param_error(param)
      render json: CustomErrorHandler::ErrorMessage.invalid_param_error(param), status: 422
    end

    def transaction_already_processed_error
      render json: CustomErrorHandler::ErrorMessage.transaction_already_processed_error, status: 422
    end

    def previous_subscription_active_error
      render json: CustomErrorHandler::ErrorMessage.previous_subscription_active_error, status: 422
    end
  end

  module Validation
    def params_prerequisite_check
      @expected_params = CustomErrorHandler::ParamValidation.new(params)
      return missing_param_error(@expected_params.missing_param) if @expected_params.missing?
      return invalid_param_error(@expected_params.invalid_param) if @expected_params.invalid?
    end

    def existing_transaction
      Transaction.find_by(transaction_ref: params[:transaction_id])
    end

    def check_if_transaction_processed
      return transaction_already_processed_error if existing_transaction.present?
    end

    def check_if_previous_subscription_still_active
      return previous_subscription_active_error if @subscription.still_active?
    end
  end

  include ErrorMessages
  include Validation

  def set_variables
    set_user
    set_subscription
  end

  def set_user
    @user = User.create_with(account_type: 'new').find_or_create_by(msisdn: params[:msisdn])
  end

  def set_subscription
    @subscription = Subscription.find_or_create_by(user_id: @user.id)
  end
end