FactoryBot.define do
  factory :item do
    name              {Faker::Lorem.word}
    description     {Faker::Lorem.sentence}
    price                {Faker::Number.number(digits: 7)}
    association :user
    association :category
    association :condition
    association :shipping_cost
    association :prefecture
    association :shipping_date

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/item-sample.png'), filename: 'item-sample.png')
    end
  end
end
