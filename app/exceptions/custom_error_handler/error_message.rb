module CustomErrorHandler
  class ErrorMessage
    class << self
      def missing_param_error(param_name)
        {
          status: 'error',
          message: "#{param_name} missing"
        }
      end

      def invalid_param_error(param_name)
        {
          status: 'error',
          message: "#{param_name} invalid"
        }
      end

      def transaction_already_processed_error
        {
          status: 'error',
          message: "Transaction already processed"
        }
      end

      def previous_subscription_active_error
        {
          status: 'error',
          message: "Previous subscription still active"
        }
      end

      def subscription_already_cancelled_error
        {
          status: 'error',
          message: "Subscription already cancelled"
        }
      end

      def subscription_already_under_trial_error
        {
          status: 'error',
          message: "Previous subscription still under trial"
        }
      end
    end
  end
end