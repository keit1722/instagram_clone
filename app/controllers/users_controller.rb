class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).order(created_at: :desc) # ユーザモデルのインスタンスを取得、ページネーションを設定、新しいユーザから順に並び替え
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user) # 引数で指定したユーザにログインするSorcery独自のメソッド
      redirect_to login_path, success: 'ユーザーを作成しました'
    else
      flash.now[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:email, :password, :password_confirmation, :username)
  end
end
