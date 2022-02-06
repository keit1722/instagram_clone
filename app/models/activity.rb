# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default("unread"), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers # ビューやコントローラ以外でURLヘルパーを利用するときに必要な記述
  belongs_to :subject, polymorphic: true # ポリモーフィック関連付け
  belongs_to :user # userモデルに関連づけ

  scope :recent, ->(count) { order(created_at: :desc).limit(count)} # 引数countの数だけ降順で表示させるscopeを定義

  # action_typeカラムで利用できるenumを定義
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  # readカラムで利用できるenumを定義
  enum read: { unread: false, read: true }

  def redirect_path # 条件によってリダイレクト先を決めるメソッドを定義
    case action_type.to_sym # action_typeをシンボル化して比較オブジェクトに指定
    when :commented_to_own_post
      # コメントがあった通知だった場合の処理。コメントがあった投稿の詳細ベージへのパス、とコメントがある場所のアンカーを返している
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      # いいねがあった通知だった場合の処理。いいねがあった投稿の詳細ベージへのパスを返している
      post_path(subject.post)
    when :followed_me
      # フォローされた通知だった場合の処理。フォローをしてきたユーザの詳細ベージへのパスを返している
      user_path(subject.follower)
    end
  end
end
