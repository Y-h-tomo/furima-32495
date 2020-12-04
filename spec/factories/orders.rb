FactoryBot.define do
  factory :order do
    postal { Faker::Address.postcode }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city { Gimei.city.kanji }
    address { Gimei.town.hiragana }
    building_name { Faker::Address.building_number }
    phone_number {Faker::Number.number(digits: 11)}

    association :purchase
  end
end
