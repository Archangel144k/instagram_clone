Rails.application.routes.draw do
  # User authentication
  devise_for :users

  # Root path
  root "posts#index"

  # Posts and nested comments
  resources :posts do
    member do
      post :like
      delete :like, to: 'posts#unlike'
      post :save
      delete :save, to: 'posts#unsave'
      post :share
    end
    resources :comments, only: [:create, :destroy]
    collection do
      get :explore
      get :saved
    end
  end

  # Users and social features
  resources :users, only: [:show, :edit, :update] do
    member do
      get :followers
      get :following
      post :follow, to: 'follows#create'
      delete :unfollow, to: 'follows#destroy'
    end
    post :message, to: 'conversations#create', as: :start_conversation_with
  end

  # Standalone routes for search, tags, and explore
  get :explore, to: 'posts#explore'
  get :search, to: 'search#index'
  get '/tags/:tag', to: 'tags#show', as: :tag

  # Notifications
  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  # Conversations and messages
  resources :conversations, only: [:index, :create, :show] do
    resources :messages, only: [:create], module: :conversations
  end

  # Activities
  resources :activities, only: [:index]

  # Reels and nested comments
  resources :reels do
    member do
      post :like, to: 'likes#create'
      delete :like, to: 'likes#destroy'
      post :save, to: 'saves#create_reel_save'
      delete :save, to: 'saves#destroy_reel_save'
    end
    resources :comments, only: [:create, :destroy]
    collection do
      get :trending
      get :discover
    end
  end

  # Stories
  resources :stories do
    member do
      post :view
    end
  end

  # Top-level comments (for polymorphic use)
  resources :comments, only: [:create, :destroy]

  # Direct route for ActiveStorage blobs
  direct :rails_blob do |blob|
    ActiveStorage::Blob.service.url(blob.key)
  end
end
