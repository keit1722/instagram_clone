# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  mount_uploaders :images, PostImageUploader # imageカラムとPostImageUploaderクラスを紐付け
  serialize :images, JSON

  validates :images, presence: true
  validates :body, presence: true, length: { maximum: 1000 }

  has_many :comments, dependent: :destroy

  # likeモデルと関連付け
  has_many :likes, dependent: :destroy

  # likeしたuserを取得できる、like_usersという関連名で利用できる
  has_many :like_users, through: :likes, source: :user

  # 「Postモデルのインスタンス.body_contain」でbodyカラムから文字を検索できるスコープ
  scope :body_contain, ->(word) { where('posts.body LIKE ?', "%#{word}%") }

  # 「Postモデルのインスタンス.comment_body_contain」でpostsテーブルにcommentsテーブルを結合、そのあとcommentsテーブルのbodyカラムから文字を検索できるスコープ
  scope :comment_body_contain,
        ->(word) { joins(:comments).where('comments.body LIKE ?', "%#{word}%") }

  # 「Postモデルのインスタンス.username_contain」でpostsテーブルにusersテーブルを結合、そのあとusernameカラムから文字を検索できるスコープ
  scope :username_contain,
        ->(word) { joins(:user).where('username LIKE ?', "%#{word}%") }
end
