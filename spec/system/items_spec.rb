require 'rails_helper'

RSpec.describe '商品の出品機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品の出品ができるとき' do
    it 'ログインしたユーザーは正しい情報を入力すれば商品が出品できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品出品のボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページに移動する
      visit new_item_path
      # サンプル画像の準備
      image_path = Rails.root.join('public/images/item-sample.png')
      # 商品詳細の入力
      attach_file('item[image]', image_path)
      fill_in 'item-name', with: @item.name
      fill_in 'item-info', with: @item.description
      select 'レディース', from: 'item-category'
      select '新品、未使用', from: 'item-sales-status'
      select '着払い(購入者負担)', from: 'item-shipping-fee-status'
      select '北海道', from: 'item-prefecture'
      select '1〜2日で発送', from: 'item-scheduled-delivery'
      fill_in 'item-price', with: @item.price
      # 出品するボタンを押すとItemモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページに出品した商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページに出品した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.name)
      # トップページに出品した商品が存在することを確認する（価格）
      expect(page).to have_content(@item.price)
      # トップページに出品した商品が存在することを確認する（送料負担）
      expect(page).to have_content('着払い(購入者負担)')
    end
  end
  context '商品の出品ができないとき' do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 商品出品のボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ボタンを押す
      find_link('出品する', href: '/items/new').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
    it 'ログインしていても正しい情報を入力しないと出品できず、出品ページにもどされる' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品出品のボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページに移動する
      visit new_item_path
      # 商品詳細の入力
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      select '--', from: 'item-category'
      select '--', from: 'item-sales-status'
      select '--', from: 'item-shipping-fee-status'
      select '--', from: 'item-prefecture'
      select '--', from: 'item-scheduled-delivery'
      fill_in 'item-price', with: ''
      # 出品するボタンを押してもItemモデルのカウントがあがらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(0)
      # 出品ページに戻されることを確認する
      expect(current_path).to eq '/items'
    end
  end
end

RSpec.describe '商品の詳細表示機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @purchase = FactoryBot.create(:purchase)
    @purchase_item = @purchase.item
  end
  context '商品の詳細情報が見れるとき' do
    it 'ログイン状態に関係なく商品詳細が確認できる' do
      # トップページに遷移する
      visit root_path
      # トップページに商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページに商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.name)
      # トップページに商品が存在することを確認する（価格）
      expect(page).to have_content(@item.price)
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 商品の詳細情報が表示されていることを確認する(画像)
      expect(page).to have_selector('img')
      # 商品の詳細情報が表示されていることを確認する(商品名)
      expect(page).to have_content(@item.name)
      # 商品の詳細情報が表示されていることを確認する(価格)
      expect(page).to have_content(@item.price)
      # 商品の詳細情報が表示されていることを確認する(説明)
      expect(page).to have_content(@item.description)
    end
  end
  context '商品の詳細表示に編集/削除が表示されるとき' do
    it 'ログイン状態の出品者のみ編集/削除ボタンが表示される' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @item.user.email
      fill_in 'password', with: @item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 商品の編集ボタンが表示されていることを確認する
      expect(page).to have_content('商品の編集')
      # 削除ボタンが表示されていることを確認する
      expect(page).to have_content('削除')
    end
  end
  context '商品の詳細表示に購入画面に進む/編集/削除が表示されないとき' do
    it 'ログアウト状態のユーザーには購入画面に進む/編集/削除ボタンが表示されない' do
      # トップページに遷移する
      visit root_path
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 商品の編集ボタンが表示されていないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 削除ボタンが表示されていないことを確認する
      expect(page).to have_no_content('削除')
      # 購入画面に進むボタンが表示されていないことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
    it 'ログイン状態でも出品者でなければ,編集/削除ボタンは表示されない' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @purchase_item.user.email
      fill_in 'password', with: @purchase_item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 商品の編集ボタンが表示されていないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 削除ボタンが表示されていないことを確認する
      expect(page).to have_no_content('削除')
    end
    it 'ログイン状態の出品者でも、売却済み商品の編集/削除ボタンは表示されない' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @purchase_item.user.email
      fill_in 'password', with: @purchase_item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@purchase_item.name, href: "/items/#{@purchase_item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@purchase_item.id}"
      # 商品の編集ボタンが表示されていないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 削除ボタンが表示されていないことを確認する
      expect(page).to have_no_content('削除')
    end
  end
  context '商品の詳細表示に購入画面に進むボタンが表示されるとき' do
    it '商品が売れていない状態で、ログイン状態の出品者以外にのみ購入に進むボタンが表示される' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @purchase_item.user.email
      fill_in 'password', with: @purchase_item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 購入画面に進むボタンが表示されていることを確認する
      expect(page).to have_content('購入画面に進む')
    end
  end
  context '商品の詳細表示に購入画面に進むボタンが表示されないとき' do
    it 'ログイン状態でも出品者には購入に進むボタンが表示されない' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @item.user.email
      fill_in 'password', with: @item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@item.name, href: "/items/#{@item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@item.id}"
      # 購入画面に進むボタンが表示されていないことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
    it '売却済みの商品にはSold Out!!の表示がされており、ログイン状態の出品者以外でも、購入に進むボタンが表示されない' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @item.user.email
      fill_in 'password', with: @item.user.password
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 商品をクリックする
      find_link(@purchase_item.name, href: "/items/#{@purchase_item.id}").click
      # 商品の詳細ページに遷移したことを確認する
      expect(current_path).to eq "/items/#{@purchase_item.id}"
      # Sold Out!!が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
      # 購入画面に進むボタンが表示されていないことを確認する
      expect(page).to have_no_content('購入画面に進む')
    end
  end
end

RSpec.describe '商品の一覧表示機能', type: :system do
  before do
    @purchase = FactoryBot.create(:purchase)
    @purchase_item = @purchase.item
    @item = FactoryBot.create(:item)
  end
  context '商品の一覧（画像/価格/商品名)が見れるとき' do
    it 'ログイン状態に関係なく商品一覧(画像/価格/商品名)が、新しい順で確認できる' do
      # トップページに遷移する
      visit root_path
      # トップページに商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページに商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.name)
      # トップページに商品が存在することを確認する（価格）
      expect(page).to have_content(@item.price)
      # 商品出品が新しい順であることを確認する
      expect(first('.item-name')).to have_content(@item.name)
    end
    it '売却済みの商品は画像上にSold Out!!の表示がされていることが確認できる' do
      # トップページに遷移する
      visit root_path
      # トップページに商品が存在することを確認する（画像）
      expect(page).to have_selector('img')
      # トップページに売却済み商品が存在することを確認する（商品名）
      expect(page).to have_content(@purchase_item.name)
      # トップページに売却済み商品が存在することを確認する（価格）
      expect(page).to have_content(@purchase_item.price)
      # Sold Out!!が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
  end
end