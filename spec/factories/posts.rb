FactoryBot.define do
  factory :post do
    body { Faker::Hacker.say_something_smart }
    images { [File.open("#{Rails.root}/spec/fixtures/fixture.png")] }
    user # userファクトリを呼び出し。関連づけされた状態にしている。
  end
end
