# 接続先のredisの設定

# サーバーの接続先
Sidekiq.configure_server do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end

# クライアントの接続先
Sidekiq.configure_client do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end