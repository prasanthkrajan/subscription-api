module CustomErrorHandler
  class InvalidParam
    class << self
      def raise_error(param_name)
        {
          status: 'error',
          message: "#{param_name} invalid"
        }
      end

      def params_confirmed_invalid?(param)
        case param
        when 'status'
          met_invalid_requirement_for_status?(param)
        when 'amount'
          met_invalid_requirement_for_amount?(param)
        when 'payment_provider'
          met_invalid_requirement_for_payment_provider?(param)
        when 'plan_code'
          met_invalid_requirement_for_plan_code?(param)
        end
      end

      private

      module Validation
        def met_invalid_requirement_for_status?(status)
          ::SubscriptionStatus::LISTED_STATUSES.exclude?(status)
        end

        def met_invalid_requirement_for_amount?(amount)
          amount.to_f < 0 || amount.to_f.nan?
        end

        def met_invalid_requirement_for_payment_provider?(payment_provider)
          ::PaymentProvider::LISTED_PROVIDERS.exclude?(payment_provider)
        end

        def met_invalid_requirement_for_plan_code?(plan_code)
          ::PlanType::LISTED_TYPES.exclude?(plan_code)
        end
      end

      include Validation

    end
  end
end