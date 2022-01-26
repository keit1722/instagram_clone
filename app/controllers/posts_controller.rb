class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]

  def index

    @posts =
      # ログイン中のユーザであれば、フォロー中ユーザと自分の投稿のみ表示（新しい順）
      if current_user
        current_user.feed.includes(:user).page(params[:page]).order(created_at: :desc)
      else
      # ログインしていなければ全ての投稿を表示する（新しい順）
        Post.all.includes(:user).page(params[:page]).order(created_at: :desc)
      end
      @users = User.recent(5) # userモデルのインスタンスを新しい順で5つ取得し@usersに代入。新しい順で取得する処理はモデルに記述。
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])

    # コメントに関する変数を用意
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:body, images: [])
  end
end
