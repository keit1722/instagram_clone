class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy] # アクションを実行する前にログインが必要
  def create
    @user = User.find(params[:followed_id]) # フォローされる対象のユーザを取得
    if current_user.follow(@user) && @user.notification_on_follow?
      # フォローされ、、なおかつ通知をONにしている場合に以下の処理を実行
      UserMailer.with(
        # mialerには以下の引数を渡している
        user_from: current_user,
        user_to: @user,
      ).follow # user_mailer.rbのfollowメソッドを実行
        .deliver_later # 非同期でメールを送信
    end
    # app/views/relationships/create.js.slimが実行される
  end

  def destroy
    @user = Relationship.find(params[:id]).followed # relationsテーブルを使ってフォロー外される対象のユーザを取得
    current_user.unfollow(@user) # カレントユーザでアンフォローする
    # app/views/relationships/destroy.js.slimが実行される
  end
end
