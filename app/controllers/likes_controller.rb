class LikesController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    if current_user.like(@post)
      # いいねされたら以下の処理を実行
      UserMailer.with(
        # mialerには以下の引数を渡している
        user_from: current_user,
        user_to: @post.user,
        post: @post,
      ).like_post # user_mailer.rbのlike_postメソッドを実行
        .deliver_later # 非同期でメールを送信
    end
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post) # userモデルで定義したunlikeメソッド
  end
end
