# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          not null
#  follower_id :integer          not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User' # userモデルに関連付け、外部キーはfollower_id
  belongs_to :followed, class_name: 'User' # userモデルに関連付け、外部キーはfollowed_id
  has_one :activity, as: :subject, dependent: :destroy # ポリモーフィック関連づけ
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id } # follower_idとfollowed_idの組み合わせに一意性制約のバリデーションをかける

  after_create_commit :create_activities # コールバックを用いてRelationshipのレコードが作られたときにcreate_activitiesメソッドを呼び出す。つまり、フォローをされたらActivityのレコードも作られる。

  private

  def create_activities
    Activity.create(subject: self, user: followed, action_type: :followed_me)
  end
end
