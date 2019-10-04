Rails.application.routes.draw do
  get 'detail/index'
  get '/search', to: 'search#index'
  get '/preview', to: 'preview#index'
  get '/submission', to: 'submission#index'
  get '/submission/error'
  get '/submission/download'
  resources :questionnaire
  get '/questionnaire', to: 'questionnaire#questionnaire'
  get '/questionnaire/error'
  root 'home#index'
  get '/error', to: 'home#error'
  get '/read_error', to: 'home#read_error'
  get '/about', to: 'about#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
