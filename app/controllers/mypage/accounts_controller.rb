class Mypage::AccountsController < Mypage::BaseController # app/controllers/mypage/base_controller.rbから継承
  def edit
    @user = User.find(current_user.id) # カレントユーザの情報をビュー側で使用できるようにする
  end

  def update
    @user = User.find(current_user.id) # カレントユーザの情報をビュー側で使用できるようにする
    if @user.update(account_params)
      # プロフィール変更成功時の処理
      redirect_to edit_mypage_account_path,
                  success: 'プロフィールを更新しました'
    else
      # プロフィール変更失敗時の処理
      flash.now['danger'] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  def account_params # ストロングパラメータ
    params.require(:user).permit(:email, :username, :avatar, :avatar_cache)
  end
end
