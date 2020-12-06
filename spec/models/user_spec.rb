require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  describe 'ユーザー情報の登録' do
    context 'ユーザー情報の登録ができるとき' do
      it 'ニックネーム、メールアドレス、パスワード、パスワード確認、本名、本名カナ、誕生日のデータが全て正しく入力されているとき、ユーザー登録ができる' do
        expect(@user).to be_valid
      end
    end

    context 'ユーザー情報の登録ができないとき' do
      it 'ニックネームが空だとユーザー登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'メールアドレスが空だとユーザー登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it 'メールアドレスが重複するとユーザー登録できない' do
        @user.save
        another_user = FactoryBot.build(:another_user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end
      it 'メールアドレスが@を含まないとユーザー登録できない' do
        @user.email = 'abcdefg.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
      it 'パスワードが空だとユーザー登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'パスワードが6文字未満だとユーザー登録できない' do
        @user.password = '1a2b3'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'パスワードを英数字混合にしないとユーザー登録できない' do
        @user.password = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end
      it 'パスワード、パスワード確認用、両方入力しないとユーザー登録できない' do
        @user.password = '1a2b3c'
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'パスワード、パスワード確認用が一致しないとユーザー登録できない' do
        @user.password = '1a2b3c'
        @user.password_confirmation = '1a2b3c4'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'ユーザー本名の苗字が空だとユーザー登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name is invalid')
      end
      it 'ユーザー本名の名前が空だとユーザー登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('First name is invalid')
      end
      it 'ユーザー本名の苗字は全角入力にしないとユーザー登録できない' do
        @user.last_name = Gimei.last.romaji
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name is invalid')
      end
      it 'ユーザー本名の名前は全角入力にしないとユーザー登録できない' do
        @user.first_name = Gimei.first.romaji
        @user.valid?
        expect(@user.errors.full_messages).to include('First name is invalid')
      end
      it 'ユーザー本名フリガナの苗字が空だとユーザー登録できない' do
        @user.last_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name kana is invalid')
      end
      it 'ユーザー本名フリガナの名前が空だとユーザー登録できない' do
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('First name kana is invalid')
      end
      it 'ユーザー本名フリガナの苗字が全角でないとユーザー登録できない' do
        @user.last_name_kana = Gimei.last.romaji
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name kana is invalid')
      end
      it 'ユーザー本名フリガナの苗字がカタカナでないとユーザー登録できない' do
        @user.last_name_kana = Gimei.last.kanji
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name kana is invalid')
      end
      it 'ユーザー本名フリガナの名前が全角でないとユーザー登録できない' do
        @user.first_name_kana = Gimei.first.romaji
        @user.valid?
        expect(@user.errors.full_messages).to include('First name kana is invalid')
      end
      it 'ユーザー本名フリガナの名前がカタカナでないとユーザー登録できない' do
        @user.first_name_kana = Gimei.first.hiragana
        @user.valid?
        expect(@user.errors.full_messages).to include('First name kana is invalid')
      end
      it '生年月日が空だとユーザー登録できない' do
        @user.birth_date = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end
    end
  end
end
