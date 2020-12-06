FactoryBot.define do
  person = Gimei.name
  factory :user, class: User do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password              { Faker::Internet.password(min_length: 6, max_length: 30) }
    password_confirmation { password }
    last_name          { person.last.kanji }
    first_name         { person.first.hiragana }
    last_name_kana  { person.last.katakana }
    first_name_kana { person.first.katakana }
    birth_date { Faker::Date.between(from: '1930-01-01', to: 5.year.from_now) }
  end
  factory :another_user, class: User do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password              { Faker::Internet.password(min_length: 6, max_length: 30) }
    password_confirmation { password }
    last_name          { person.last.kanji }
    first_name         { person.first.hiragana }
    last_name_kana  { person.last.katakana }
    first_name_kana { person.first.katakana }
    birth_date { Faker::Date.between(from: '1930-01-01', to: 5.year.from_now) }
  end
end
