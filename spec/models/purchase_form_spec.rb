require 'rails_helper'

RSpec.describe PurchaseForm, type: :model do
  before do
    @purchase_form = FactoryBot.build(:purchase_form)
  end
  describe '商品の購入' do
    context '商品の購入ができる時' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@purchase_form).to be_valid
      end
      it '建物名が未入力でもその他の情報が入力されていれば購入できる' do
        @purchase_form.building_name = nil
        expect(@purchase_form).to be_valid
      end
    end

    context '商品の購入ができない時' do
      it '郵便番号が空だと購入できない' do
        @purchase_form.postal = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Postal can't be blank")
      end
      it '郵便番号にハイフンが入っていないと購入できない' do
        @purchase_form.postal = Faker::Number.number(digits: 7)
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Postal is invalid')
      end
      it '都道府県の選択がされていないと購入できない' do
        @purchase_form.prefecture_id = 1
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Prefecture must be other than 1')
      end
      it '市区町村の入力がされていないと購入できない' do
        @purchase_form.city = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("City can't be blank")
      end
      it '番地の入力がされていないと購入できない' do
        @purchase_form.address = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Address can't be blank")
      end
      it '電話番号が入力されていないと購入できない' do
        @purchase_form.phone_number = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Phone number can't be blank")
      end
      it '電話番号が12桁以上だと購入できない' do
        @purchase_form.phone_number = "0#{rand(0..9)}0#{rand(100_000_000..999_999_999)}"
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号が9桁以下だと購入できない' do
        @purchase_form.phone_number = "0#{rand(0..9)}0#{rand(100_000..999_999)}"
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号の最初が0[0~9]0になっていないと購入できない' do
        @purchase_form.phone_number = "1#{rand(0..9)}2#{rand(1_000_000..99_999_999)}"
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号にハイフンが入っていると購入できない' do
        @purchase_form.phone_number = "0#{rand(0..9)}0-#{rand(1_000_000..99_999_999)}"
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
      end
      it '商品情報が紐づいていないと購入できない' do
        @purchase_form.item_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Item can't be blank")
      end
      it 'ユーザー情報が紐づいていないと購入できない' do
        @purchase_form.user_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("User can't be blank")
      end
      it 'カード情報が得られていないと購入できない' do
        @purchase_form.token = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end
