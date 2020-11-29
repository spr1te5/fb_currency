Rails.application.routes.draw do
  root to: 'dashboard#display'

  get '/admin', to: 'dashboard#admin'
  patch '/admin/update_rate', to: 'dashboard#update_rate'

  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
