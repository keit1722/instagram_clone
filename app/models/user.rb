# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#

# Sorceryのジェネレータによって自動生成されたUserモデル

class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  # Sorceryを使ったパスワードのバリデーション
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy # 親モデルを削除する場合に紐づく子モデルを一緒に削除できるよう設定
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy # likeモデルと関連付け
  has_many :like_posts, through: :likes, source: :post # likeしたpostを取得できる、like_postsという関連名で利用できる

  # ユーザーが自身の子モデルのオブジェクトかどうかをを判定するメソッド
  def own?(object)
    id == object.user_id
  end
end
