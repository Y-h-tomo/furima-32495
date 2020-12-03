require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end
  describe '商品の登録' do
    context '商品が出品できる時' do
      it '画像、商品名、商品説明、状態、配送料の負担、発送元の地域、発送までの日数、価格全ての情報が正しく入力されていたら、商品が出品できる' do
        expect(@item).to be_valid
      end
    end

    context '商品が出品できない時' do
      it '商品画像をつけていないと商品登録できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
      it '商品名がないと商品登録できない' do
        @item.name = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Name can't be blank")
      end
      it '商品説明がないと商品登録できない' do
        @item.description = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Description can't be blank")
      end
      it 'カテゴリー選択をしていないと商品登録できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Category must be other than 1')
      end
      it '商品の状態についての選択をしていないと商品登録できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Condition must be other than 1')
      end
      it '配送料の負担についての情報の選択をしていないと商品登録できない' do
        @item.shipping_cost_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping cost must be other than 1')
      end
      it '発送元の地域についての情報の選択をしていないと商品登録できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Prefecture must be other than 1')
      end
      it '発送までの日数についての情報の選択をしていないと商品登録できない' do
        @item.shipping_date_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping date must be other than 1')
      end
      it '価格の設定をしていないと商品登録できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end
      it '価格の範囲が300円未満だと商品登録できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be greater than 300')
      end
      it '価格の範囲が10,000,000円以上だと商品登録できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be less than 9999999')
      end
      it '価格設定が全角だと商品登録できない' do
        @item.price = '12345'.tr('0-9', '０-９')
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
    end
  end
end
