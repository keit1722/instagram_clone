class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password]) # 引数をもとにユーザを探してログインするSorcery独自のメソッド

    if @user
      redirect_back_or_to posts_path, success: 'ログインしました' # フレンドリーフォワーディングのためのSorcery独自のメソッド
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout # ログアウトするためのSorcery独自のメソッド
    redirect_to root_path, success: 'ログアウトしました'
  end
end
