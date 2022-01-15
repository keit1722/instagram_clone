class ApplicationController < ActionController::Base
  # フラッシュメッセージのキーを追加
  add_flash_types :success, :info, :warning, :danger
end
