Rails.application.routes.draw do
  resources :todos
  get '/', to: redirect('/todos')
end
