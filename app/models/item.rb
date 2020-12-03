class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  has_one_attached :image

  belongs_to_active_hash :category
  belongs_to_active_hash :condition
  belongs_to_active_hash :shipping_cost
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :shipping_date

  validates :image, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, format: { with: /\A[0-9]+\z/ }, numericality: { greater_than: 300, less_than: 9_999_999 }

  validates :category_id, numericality: { other_than: 1 }
  validates :condition_id, numericality: { other_than: 1 }
  validates :shipping_cost_id, numericality: { other_than: 1 }
  validates :prefecture_id, numericality: { other_than: 1 }
  validates :shipping_date_id, numericality: { other_than: 1 }
end
