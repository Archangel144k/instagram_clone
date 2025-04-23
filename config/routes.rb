Rails.application.routes.draw do
  devise_for :users
  
  # Root path - the main feed
  root "posts#index"
  
  # Posts with nested comments and actions
  resources :posts do
    member do
      post 'like', to: 'likes#create'
      delete 'like', to: 'likes#destroy'
      
      post 'save', to: 'saves#create'
      delete 'save', to: 'saves#destroy'
      
      post 'share'
    end
    resources :comments, only: [:create, :destroy]
    collection do
      get 'explore'
      get 'saved'
    end
  end
  
  # User profiles and relationships
  resources :users, only: [:show, :edit, :update] do
    member do
      get 'followers'
      get 'following'
      post 'follow', to: 'users#follow'
      delete 'follow', to: 'users#unfollow'
    end
    post 'message', to: 'conversations#create', as: :start_conversation_with
  end

  # Additional routes
  get 'explore', to: 'posts#explore'
  get 'search', to: 'search#index'
  get '/tags/:tag', to: 'tags#show', as: :tag
  
  # Notifications
  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
  
  # Direct messaging
  resources :conversations, only: [:index, :create, :show] do
    resources :messages, only: [:create], module: :conversations
  end

  # Activities
  resources :activities, only: [:index]

  resources :users do
    member do
      post 'follow', to: 'users#follow'
      delete 'follow', to: 'users#unfollow'
    end
  end

  # Reels with nested comments and actions
  resources :reels do
    member do
      post 'like', to: 'likes#create'
      delete 'like', to: 'likes#destroy'
      post 'save', to: 'saves#create_reel_save'
      delete 'save', to: 'saves#destroy_reel_save'
    end
    resources :comments, only: [:create, :destroy]
    collection do
      get 'trending'
      get 'discover'
    end
  end

  # Stories
  resources :stories, only: [:index, :create, :show]
end
