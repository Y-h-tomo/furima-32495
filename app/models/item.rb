class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  has_one_attached :image

  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_cost
  belongs_to :prefecture
  belongs_to :shipping_date

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, format: { with: /\A[0-9]+\z/ }, numericality: { greater_than: 300, less_than: 9_999_999 }

  validates :category_id, numericality: { other_than: 1 }
  validates :condition_id, numericality: { other_than: 1 }
  validates :shipping_cost_id, numericality: { other_than: 1 }
  validates :prefecture_id, numericality: { other_than: 1 }
  validates :shipping_date_id, numericality: { other_than: 1 }
end