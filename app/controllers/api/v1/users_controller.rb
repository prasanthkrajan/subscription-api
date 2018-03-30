class Api::V1::UsersController < API::BaseController
  def show
    @user = User.find_by(params[:msisdn])
    @subscription = @user.subscription
    @transactions = @subscription.transactions
    @message = 'User Info Retrieved'
    @status = 'success'
  end
end