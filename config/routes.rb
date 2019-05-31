Rails.application.routes.draw do
  resources :questionnaire
  get '/questionnaire', to: 'questionnaire#questionnaire'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
