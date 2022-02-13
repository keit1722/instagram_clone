require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:user) { create(:user) } # ユーザを新規作成

  describe 'ログイン' do
    context '認証情報が正しい場合' do
      it 'ログインできること' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678' # パスワードの項目に12345678と入力
        click_button 'ログイン'
        expect(current_path).to eq posts_path # 投稿一覧画面へ移行していればテスト成功
        expect(page).to have_content 'ログインしました' # 「ログインしました」と表示されればテスト成功
      end
    end

    context '認証情報に誤りがある場合' do
      it 'ログインできないこと' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '1234' # パスワードの項目に1234と入力
        click_button 'ログイン'
        expect(current_path).to eq login_path # ログイン画面が表示されていればテスト成功
        expect(page).to have_content 'ログインに失敗しました' # 「ログインに失敗しました」と表示されればテスト成功
      end
    end
  end

  describe 'ログアウト' do
    before { login } # example処理の前にloginメソッドを実行
    it 'ログアウトできること' do
      click_on('ログアウト') # ログアウトボタンををクリック
      expect(current_path).to eq login_path # ログイン画面へ移行していればテスト成功
      expect(page).to have_content 'ログアウトしました' # 「ログアウトしました」と表示されればテスト成功
    end
  end
end
