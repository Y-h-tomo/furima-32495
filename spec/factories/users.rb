FactoryBot.define do
  person = Gimei.name
  factory :user, class: User do |user|
    user.nickname              { Faker::Name.name }
    user.email                 { Faker::Internet.free_email }
    user.sequence(:password)              { |n| "#{n}#{Faker::Internet.password(min_length: 6)}" }
    user.password_confirmation { password }
    user.last_name          { person.last.kanji }
    user.first_name         { person.first.hiragana }
    user.last_name_kana  { person.last.katakana }
    user.first_name_kana { person.first.katakana }
    user.birth_date { Faker::Date.between(from: '1930-01-01', to: 5.year.from_now) }
  end
end
