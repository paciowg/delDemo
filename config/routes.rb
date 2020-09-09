Rails.application.routes.draw do
  get '/detail', to: 'detail#index'
  get '/search', to: 'search#index'
  get '/search_ehr', to: 'search_ehr#index'
  get '/search_patient', to: 'search_patient#index'
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
  get '/patient', to: 'patient#index'
  get '/ehr', to: 'ehr#index'
  get '/ehr_send', to: 'ehr_send#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
