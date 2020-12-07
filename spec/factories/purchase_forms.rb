FactoryBot.define do
  factory :purchase_form do
    postal { "#{rand(100..999)}-#{rand(1_000..9_999)}" }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city { Gimei.city.kanji }
    address { Gimei.town.hiragana }
    building_name { Faker::Address.building_number }
    phone_number { "0#{rand(0..9)}0#{rand(1_000_000..99_999_999)}" }
    user_id { Faker::Number.number(digits: 10) }
    item_id { Faker::Number.number(digits: 10) }
    token { 'tok_abcdefghijk00000000000000000' }
  end
end
