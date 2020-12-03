class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze

  validates :nickname, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, format: { with: PASSWORD_REGEX }
  validates :first_name, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/ }
  validates :last_name, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/ }
  validates :first_name_kana, format: { with: /\A[ァ-ン]+\z/ }
  validates :last_name_kana, format: { with: /\A[ァ-ン]+\z/ }
  validates :birth_date, presence: true

  has_many :items
end
