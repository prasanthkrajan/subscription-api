class Api::V1::SubscriptionsController < API::BaseController

  before_action :params_prerequisite_check, only: :callback
  before_action :check_if_transaction_processed, only: :callback
  before_action :set_variables, except: :callback
  before_action :check_if_previous_subscription_still_active, only: :update
  before_action :check_if_subscription_can_set_trial, only: :trial

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
    @subscription.renew_billing(params)
    @subscription.reload
    @message = 'Subscription successfully updated'
    @status = 'success'
    render :subscription, status: 200
  end

  def trial
    @subscription.set_to_trial(params)
    @subscription.reload
    @message = 'Subscription successfully set to trial'
    @status = 'success'
    render :subscription, status: 200
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

    def subscription_already_cancelled_error
      render json: CustomErrorHandler::ErrorMessage.subscription_already_cancelled_error, status: 422
    end

    def subscription_already_under_trial_error
      render json: CustomErrorHandler::ErrorMessage.subscription_already_under_trial_error, status: 422
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
      return previous_subscription_active_error if @subscription.active?
    end

    def check_if_subscription_can_set_trial
      return subscription_already_cancelled_error if @subscription.cancelled?
      return previous_subscription_active_error if @subscription.active?
      return subscription_already_under_trial_error if @subscription.trial?
    end
  end

  include ErrorMessages
  include Validation

  def set_variables
    set_user
    set_subscription
  end

  def set_user
    @user = User.create_with(account_type: AccountType::NEW).find_or_create_by(msisdn: params[:msisdn])
  end

  def set_subscription
    @subscription = Subscription.find_or_create_by(user_id: @user.id)
  end
end