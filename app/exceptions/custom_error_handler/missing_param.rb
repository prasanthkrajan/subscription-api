module CustomErrorHandler
  class MissingParam
    class << self
      def raise_error(param_name)
        {
          status: 'error',
          message: "#{param_name} missing"
        }
      end
    end
  end
end