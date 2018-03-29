module CustomErrorHandler
  class ParamValidation
    attr_accessor :expected_params
    def initialize(expected_params)
      @expected_params = expected_params
    end

    def missing?
      missing_params.present?
    end

    def invalid?
      invalid_params.present?
    end

    def missing_param
      missing_params.first
    end

    def invalid_param
      invalid_params.first
    end

    private

    def missing_params
      required_params - expected_params.keys
    end

    def invalid_params
      invalid_param_keys  = []
      expected_params.each do |k,v|
        invalid_param_keys << CustomErrorHandler::InvalidParamChecker.check_and_return(k,v)
      end
      invalid_param_keys.compact
    end

    def required_params
      [
        'msisdn',
        'payment_provider',
        'amount',
        'transaction_id',
        'status',
        'plan_code'
      ]
    end
  end
end