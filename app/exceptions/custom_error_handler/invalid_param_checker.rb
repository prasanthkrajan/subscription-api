module CustomErrorHandler
  class InvalidParamChecker
    class << self
      def check_and_return(key,value)
        case key
        when 'status'
          return key if met_invalid_requirement_for_status?(value)
        when 'amount'
          return key if met_invalid_requirement_for_amount?(value)
        when 'payment_provider'
          return key if met_invalid_requirement_for_payment_provider?(value)
        when 'plan_code'
          return key if met_invalid_requirement_for_plan_code?(value)
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