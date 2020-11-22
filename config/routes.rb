Rails.application.routes.draw do
  root to: 'dashboard#display'

  get '/admin', to: 'dashboard#admin'
  patch '/admin/update_rate', to: 'dashboard#update_rate'
  get '/broadcast_currency_update', to: 'dashboard#broadcast_currency_update'

  mount ActionCable.server => '/cable'
end
