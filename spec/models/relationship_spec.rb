require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'バリデーション' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let!(:relationship) do
      create(:relationship, followed_id: user_a.id, follower_id: user_b.id)
    end
    it '同じユーザーからフォローされたり、同じユーザーをフォローすることができないこと' do
      relationship_again =
        build(:relationship, followed_id: user_a.id, follower_id: user_b.id)
      relationship_again.valid?
      expect(relationship_again.errors[:follower_id]).to include(
        'はすでに存在します',
      )
    end
  end

  describe 'コールバック' do
    describe 'after_create_commit' do
      let(:relationship) { create(:relationship) }
      it 'Activityモデルのインスタンスが作成される' do
        expect { relationship }.to change { Activity.count }.by(1)
      end
    end
  end
end
