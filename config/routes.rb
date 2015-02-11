Rails.application.routes.draw do
  get '/' => 'console#show'
  post '/x' => 'console#execute'
  get '/t' => 'console#template'
  get '/kill' => 'console#empty_db'
  get '/data.json' => 'console#show_json'
end
