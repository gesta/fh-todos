Rails.application.routes.draw do
  resources :todos
  get '/', to: redirect('/todos')

  get '/api/v1/todos', to: 'todos#index'
  get '/api/v1/todos/:id', to: 'todos#edit'
  post '/api/v1/todos', to: 'todos#create'
  patch '/api/v1/todos/:id', to: 'todos#update'
  put '/api/v1/todos/:id', to: 'todos#update'
  delete '/api/v1/todos/:id', to: 'todos#destroy'
end
