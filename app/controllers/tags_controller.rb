class TagsController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.where("caption LIKE ?", "%##{@tag}%").order(created_at: :desc)
    @reels = Reel.where("caption LIKE ?", "%##{@tag}%").order(created_at: :desc)
    
    @records = (@posts + @reels).sort_by(&:created_at).reverse
  end
end