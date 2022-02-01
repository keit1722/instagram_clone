class ApplicationController < ActionController::Base
  # 全てのアクション前に@search_formを生成
  before_action :set_search_posts_form

  # フラッシュメッセージのキーを追加
  add_flash_types :success, :info, :warning, :danger

  # Sorceryのrequire_loginメソッドで使用されるnot_authenticatedメソッドをオーバーライド
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  private

  # 検索様に用いる変数@search_formを生成
  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end

  # paramsの中の :q が空だった場合{}を返す
  def search_post_params
    params.fetch(:q, {}).permit(:body, :comment_body, :username)
  end
end
