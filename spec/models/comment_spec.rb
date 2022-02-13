# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    it '本文は必要であること' do
      comment = build(:comment, body: nil)
      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end

    it '本文は1000文字以内であること' do
      comment = build(:post, body: 'a' * 1001)
      comment.valid?
      expect(comment.errors[:body]).to include(
        'は1000文字以内で入力してください',
      )
    end
  end

  describe 'コールバック' do
    describe 'after_create_commit' do
      let(:comment) { create(:comment) }
      it 'Activityモデルのインスタンスが作成される' do
        expect { comment }.to change { Activity.count }.by(1)
      end
    end
  end
end
