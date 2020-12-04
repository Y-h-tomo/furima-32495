class Order < ApplicationRecord
  require 'faker'
  Faker::Config.locale = :ja
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :purchase
  belongs_to_active_hash :prefecture
end
