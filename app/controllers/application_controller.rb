class ApplicationController < ActionController::Base
  # フラッシュメッセージのキーを追加
  add_flash_types :success, :info, :warning, :danger

  # Sorceryのrequire_loginメソッドで使用されるnot_authenticatedメソッドをオーバーライド
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end
end
