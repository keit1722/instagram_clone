class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save && @comment.post.user.notification_on_comment?
      # コメントされ、なおかつ通知をONにしている場合に以下の処理を実行
      UserMailer.with(
        # mialerには以下の引数を渡している
        user_from: current_user,
        user_to: @comment.post.user,
        comment: @comment,
      ).comment_post # user_mailer.rbのcomment_postメソッドを実行
        .deliver_later # 非同期でメールを送信
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
