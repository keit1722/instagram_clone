FactoryBot.define do
  factory :comment do
    body { Faker::Movies::StarWars.quote }
    post
    user
  end
end
