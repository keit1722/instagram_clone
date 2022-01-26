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
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy # relationshipsへの関連名をactive_relationshipsとして宣言、外部キーをfollower_idに設定
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy # relationshipsへの関連名をpassive_relationshipsとして宣言、外部キーをfollowed_idに設定
  has_many :following, through: :active_relationships, source: :followed # フォローしているユーザーの集合を取得できるようactive_relationshipsメソッドを設定
  has_many :followers, through: :passive_relationships, source: :follower # フォローされているユーザーの集合を取得できるようpassive_relationshipsメソッドを設定

  scope :randoms, -> (count) { order("RAND()").limit(count) } # インスタンスをランダムに並べてcountの数だけ取得して返す

  # ユーザーが自身の子モデルのオブジェクトかどうかをを判定するメソッド
  def own?(object)
    id == object.user_id
  end

  # 中間テーブルであるlikesテーブルに引数で渡されたpostを新たなレコードとして加える。Like.create!(post_id: post.id, user_id: post.user.id)と同じ意味。
  def like(post)
    like_posts << post
  end

  # like_postsから引数で渡されたpostを削除
  def unlike(post)
    like_posts.destroy(post)
  end

  # like_postsの中に引数で渡されたpostが含まれているか否かをbooleanで返す
  def like?(post)
    like_posts.include?(post)
  end

  # フォローしているユーザの集合に引数で受け取ったother_userを加える
  def follow(other_user)
    following << other_user
  end

  # relationshipsテーブルから引数で受け取ったother_userを削除、結果的にアンフォローする
  def unfollow(other_user)
    following.delete(other_user)
  end

  # followingの中に引数で渡されたpostが含まれているか否かをbooleanで返す、フォローしているかどうかを調べる
  def following?(other_user)
    following.include?(other_user)
  end

  # フォローしているユーザーのidと自身のidの投稿の一覧を取得して返している
  def feed
    Post.where(user_id: following_ids << id)
  end
end
