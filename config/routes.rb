Rails.application.routes.draw do
  match "/delayed_job", to: DelayedJobWeb, anchor: false, via: [:get, :post]
  get('/by/pcap/', { to: 'parse_logs#pcap', as: 'pcap'})

  get('/', { to: 'parse_logs#index', as: 'home' })
  get('/all', { to: 'parse_logs#all' })
  get('/hour', { to: 'parse_logs#hour' })
  get('/day', { to: 'parse_logs#day' })
  get('/week', { to: 'parse_logs#week' })
  get('/by', { to: 'parse_logs#by', as: 'by'})

end
