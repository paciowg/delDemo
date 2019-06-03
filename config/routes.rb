Rails.application.routes.draw do
  resources :submission
  get '/submission', to: 'submission#index'
  get '/submission/error'
  resources :questionnaire
  get '/questionnaire', to: 'questionnaire#questionnaire'
  get '/questionnaire/error'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
