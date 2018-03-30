require "spec_helper"  
require "rails_helper" 

RSpec.describe Api::V1::SubscriptionsController, :type => :controller do
  fixtures :all
  
  describe 'GET callback' do 
    it 'should throw error when status is missing' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('status missing')
    end

    it 'should throw error when status is invalid' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: Faker::Lorem.characters(Random.rand(3)),
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('status invalid')
    end

    it 'should throw error when amount is missing' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('amount missing')
    end

    it 'should throw error when amount is invalid' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.negative(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::CANCELLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('amount invalid')
    end

    it 'should throw error when payment provider is missing' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('payment_provider missing')
    end

    it 'should throw error when payment provider is not recognized' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: Faker::Lorem.characters(Random.rand(3)),
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::CANCELLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('payment_provider invalid')
    end

    it 'should throw error when plan code is missing' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('plan_code missing')
    end

    it 'should throw error when plan code is invalid' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: Faker::Lorem.characters(Random.rand(3))
      }
      get :callback, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('plan_code invalid')
    end

    it 'should throw error when transaction is already processed' do 
    end

    it 'should redirect to update subcription path if status is billed' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to redirect_to(update_subscription_path)
    end

    it 'should redirect to trial subcription path if status is trial' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to redirect_to(trial_subscription_path)
    end

    it 'should redirect to cancel subscription path is status is cancelled' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::CANCELLED,
        plan_code: PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      expect(response).to redirect_to(cancel_subscription_path)
    end
  end


  describe 'GET update' do 
    it 'should throw error when previous subscription is still active' do
      subscription = subscriptions(:subscription_two)
      user = users(:user_three)
      params = {
        msisdn: user.msisdn,
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED,
        plan_code: PlanType::MONTHLY
      }
      get :update, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('Previous subscription still active')
    end

    it 'should display a success message when subscription is successfully updated' do 
      subscription = subscriptions(:subscription_one)
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::BILLED,
        plan_code: PlanType::MONTHLY
      }
      get :update, params
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('success')
      expect(parsed_response['message']).to eq('Subscription successfully updated')
      expect(parsed_response['subscription']).to eq(subscription.to_json)
    end
  end

  describe 'GET trial' do 
    it 'should throw error when a cancelled subscription is set to trial' do 
      subscription = subscriptions(:cancelled_subscription)
      user = users(:user_five)
      params = {
        msisdn: user.id,
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: PlanType::MONTHLY
      }
      get :trial, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('Subscription already cancelled')
    end
    
    it 'should throw error when an active subscription is set to trial' do 
      subscription = subscriptions(:subscription_two)
      user = users(:user_five)
      params = {
        msisdn: user.id,
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: PlanType::MONTHLY
      }
      get :trial, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('Previous subscription still active')
    end

    it 'should throw error when an already trial subscription is set to trial' do 
      subscription = subscriptions(:trial_subscription)
      user = users(:user_five)
      params = {
        msisdn: user.id,
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: PlanType::MONTHLY
      }
      get :trial, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('Previous subscription still under trial')
    end

    it 'should display a success message when a subscription is successfully set as trial' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::TRIAL,
        plan_code: PlanType::MONTHLY
      }
      get :trial, params
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('success')
      expect(parsed_response['message']).to eq('Subscription successfully set to trial')
      expect(parsed_response['subscription']).to eq(subscription.to_json)
    end
  end

  describe 'GET cancel' do 
    
    it 'should throw error when an already cancelled subscription is set to cancel' do 
      subscription = subscriptions(:cancelled_subscription)
      user = users(:user_five)
      params = {
        msisdn: user.id,
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::CANCELLED,
        plan_code: PlanType::MONTHLY
      }
      get :cancel, params
      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('error')
      expect(parsed_response['message']).to eq('Subscription already cancelled')
    end

    it 'should display a success message when a subscription is successfully cancelled' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: SubscriptionStatus::CANCELLED,
        plan_code: PlanType::MONTHLY
      }
      get :cancel, params
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('success')
      expect(parsed_response['message']).to eq('Subscription cancelled')
      expect(parsed_response['subscription']).to eq(subscription.to_json)
    end
  end
end