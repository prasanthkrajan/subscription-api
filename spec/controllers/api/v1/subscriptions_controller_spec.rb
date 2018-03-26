require "spec_helper"  
require "rails_helper" 

RSpec.describe Api::V1::SubscriptionsController, :type => :controller do
  describe 'GET callback' do 
    it 'should throw error when params are insufficient' do 
    end

    it 'should redirect to update subcription path if status is billed' do 
    end

    it 'should redirect to update subcription path if status is trial' do 
    end

    it 'should redirect to cancel subscription path is status is cancelled' do 
    end
  end

  describe 'POST update_subscription' do 
    it 'should throw error when amount is less than 0' do 
    end

    it 'should throw error when amount is invalid' do 
    end

    it 'should throw error when payment provider is not recognized' do 
    end

    it 'should throw error when status is invalid' do 
    end

    it 'should throw error when plan code is invalid' do 
    end

    it 'should throw error when transaction is already processed' do 
    end

    it 'should display a success message when subscription is successfully updated' do 
    end
  end

  describe 'POST cancel_subscription' do 
    it 'should throw error when payment provider is not recognized' do 
    end

    it 'should throw error when status is invalid' do 
    end

    it 'should throw error when transaction is already processed' do 
    end

    it 'should display a success message when a subscription is successfully cancelled' do 
    end
  end
end