Rails.application.routes.draw do

  get('/', { to: 'parse_logs#index', as: 'home' })
  get('/hour', { to: 'parse_logs#hour' })
  get('/day', { to: 'parse_logs#day' })
  get('/week', { to: 'parse_logs#week' })

end
