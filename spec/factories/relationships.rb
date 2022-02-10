FactoryBot.define do
  factory :relationship do
    sequence(:followed_id) { |n| n }
    sequence(:follower_id) { |n| n }
    association :follower, factory: :user
    association :followed, factory: :user
  end
end
