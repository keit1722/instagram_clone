class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[read]

  def read
    activity = current_user.activities.find(params[:id])
    activity.read! if activity.unread? # readカラムがunreadだった場合、readに変更する（モデルに記述したenumにより可能になった処理）
    redirect_to activity.redirect_path # モデルに記述したredirect_pathメソッドの戻り値にリダイレクト
  end
end
