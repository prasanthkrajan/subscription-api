Rails.application.routes.draw do
 get 'callback' => 'api/v1/subscriptions#callback'
 get 'subscriptions/update' => 'api/v1/subscriptions#update', as: :update_subscription
 get 'subscriptions/trial' => 'api/v1/subscriptions#trial', as: :trial_subscription
 get 'subscriptions/cancel' => 'api/v1/subscriptions#cancel', as: :cancel_subscription

 get 'users/:msisdn' => 'api/v1/users#show'
end
