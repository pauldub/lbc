Lbc::Application.routes.draw do
  get "links/fetch"

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'

  get 'signup' => 'users#new', :as => 'signup'

  resources :users

  resources :searches do
    get :bookmarks, on: :collection
    get :likes, on: :collection
    get :recommendations, on: :collection

    get :results, on: :member
    get 'results/page/:page', :action => :results, :on => :member

    get :statistics, on: :member
    get :run, on: :member
    put :share, on: :member

    resources :links do
      get :fetch, on: :member

      get :like, on: :member
      get :dislike, on: :member

      get :bookmark, on: :member
      get :remove_bookmark, on: :member

      get :hide, on: :member
    end
  end

  resources :sessions

  root :to => 'high_voltage/pages#show', id: 'home'
end
