require "spec_helper"  
require "rails_helper" 

RSpec.describe Api::V1::SubscriptionsController, :type => :controller do
  describe 'GET callback' do 
=begin
    it 'should throw error when status is missing' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: Constants::PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        plan_code: Constants::PlanType::LISTED_TYPES.sample
      }
      get :callback, params
    end

    it 'should throw error when status in invalid' do 
    end
=end

    it 'should redirect to update subcription path if status is billed' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: Constants::PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: Constants::SubscriptionStatus::BILLED,
        plan_code: Constants::PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      response.should redirect_to (update_subscription_path, method: :post)
    end

    it 'should redirect to trial subcription path if status is trial' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: Constants::PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: Constants::SubscriptionStatus::TRIAL
        plan_code: Constants::PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      response.should redirect_to (trial_subscription_path, method: :post)
    end

    it 'should redirect to cancel subscription path is status is cancelled' do 
      params = {
        msisdn: Faker::Lorem.characters(Random.rand(20)),
        payment_provider: Constants::PaymentProvider::LISTED_PROVIDERS.sample,
        amount: Faker::Number.decimal(Random.rand(4)),
        transaction_id: Faker::Lorem.characters(Random.rand(20)),
        status: Constants::SubscriptionStatus::CANCELLED,
        plan_code: Constants::PlanType::LISTED_TYPES.sample
      }
      get :callback, params
      response.should redirect_to (cancel_subscription_path, method: :post)
    end
  end

=begin
  describe 'POST update_subscription' do 
    it 'should throw error when amount is missing' do 
    end

    it 'should throw error when amount is less than 0' do 
    end

    it 'should throw error when amount is invalid' do 
    end

    it 'should throw error when payment provider is missing' do 
    end

    it 'should throw error when payment provider is not recognized' do 
    end

    it 'should throw error when plan code is missing' do 
    end

    it 'should throw error when plan code is invalid' do 
    end

    it 'should throw error when transaction is already processed' do 
    end

    it 'should display a success message when subscription is successfully updated' do 
    end
  end

  describe 'POST cancel_subscription' do 
    it 'should throw error when payment provider is missing' do 
    end
    
    it 'should throw error when payment provider is not recognized' do 
    end

    it 'should throw error when transaction is already processed' do 
    end

    it 'should display a success message when a subscription is successfully cancelled' do 
    end
  end
=end
end