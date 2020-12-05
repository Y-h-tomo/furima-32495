class PurchaseForm
  include ActiveModel::Model
  attr_accessor :postal, :prefecture_id, :city, :address, :building_name, :phone_number, :purchase_id, :user_id, :item_id, :token

  VALID_POSTAL_NUMBER_REGEX = /\A\d{3}-\d{4}\z/.freeze
  VALID_PHONE_NUBER_REGEX = /\A0+[0-9]+0+\d{7,8}\z/.freeze

  with_options presence: true do
    validates :postal, format: { with: VALID_POSTAL_NUMBER_REGEX }
    validates :city
    validates :address
    validates :phone_number, format: { with: VALID_PHONE_NUBER_REGEX }
    validates :user_id
    validates :item_id
    validates :token
  end
  validates :prefecture_id, numericality: { other_than: 1 }

  def save!
    purchase = Purchase.create(item_id: item_id, user_id: user_id)
    Order.create(
      postal: postal,
      prefecture_id: prefecture_id,
      city: city,
      address: address,
      building_name: building_name,
      phone_number: phone_number,
      purchase_id: purchase.id
    )
  end
end
