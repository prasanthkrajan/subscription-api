Rails.application.routes.draw do
 get 'callback' => 'subscriptions#callback'
 post 'subscriptions/update' => 'subscriptions#update', as: :update_subscription
 post 'subscriptions/trial' => 'subscriptions#trial', as: :trial_subscription
 post 'subscriptions/cancel' => 'subscriptions#cancel', as: :cancel_subscription
end
