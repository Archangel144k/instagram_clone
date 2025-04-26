Rails.application.routes.draw do
  devise_for :users

  root "posts#index"

  resources :posts do
    member do
      post 'like'
      delete 'like', to: 'posts#unlike'
      post 'save'
      delete 'save', to: 'posts#unsave' # This creates unsave_post_path(@post)
      post 'share'
    end
    resources :comments, only: [:create, :destroy]
    collection do
      get 'explore'
      get 'saved'
    end
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :followers # Add route for followers list
      get :following # Add route for following list
      post 'follow', to: 'follows#create' # Use FollowsController
      delete 'unfollow', to: 'follows#destroy' # Use FollowsController
    end
    post 'message', to: 'conversations#create', as: :start_conversation_with
  end

  get 'explore', to: 'posts#explore'
  get 'search', to: 'search#index'
  get '/tags/:tag', to: 'tags#show', as: :tag

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  resources :conversations, only: [:index, :create, :show] do
    resources :messages, only: [:create], module: :conversations
  end

  resources :activities, only: [:index]

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

  resources :stories do
    member do
      post 'view'
    end
  end

  resources :comments, only: [:create, :destroy]

  direct :rails_blob do |blob|
    ActiveStorage::Blob.service.url(blob.key)
  end
end
