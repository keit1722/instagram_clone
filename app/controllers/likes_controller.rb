class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]
  
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post) # userモデルで定義したlikeメソッド
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post) # userモデルで定義したunlikeメソッド
  end
end
