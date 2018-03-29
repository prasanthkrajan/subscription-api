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
    end
  end
end