require 'sidekiq/web'
require 'sidekiq-scheduler/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get('/by/pcap/', { to: 'parse_logs#pcap', as: 'pcap'})

  root :to => 'parse_logs#index'
  get('/', { to: 'parse_logs#index', as: 'home' })
  get('/all', { to: 'parse_logs#all' })
  get('/hour', { to: 'parse_logs#hour' })
  get('/day', { to: 'parse_logs#day' })
  get('/week', { to: 'parse_logs#week' })
  get('/by', { to: 'parse_logs#by', as: 'by'})

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

end
