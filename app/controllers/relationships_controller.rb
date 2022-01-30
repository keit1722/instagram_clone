class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy] # アクションを実行する前にログインが必要
  def create
    @user = User.find(params[:followed_id]) # フォローされる対象のユーザを取得
    current_user.follow(@user) # カレントユーザでフォローする
    # app/views/relationships/create.js.slimが実行される
  end

  def destroy
    @user = Relationship.find(params[:id]).followed # relationsテーブルを使ってフォロー外される対象のユーザを取得
    current_user.unfollow(@user) # カレントユーザでアンフォローする
    # app/views/relationships/destroy.js.slimが実行される
  end
end
