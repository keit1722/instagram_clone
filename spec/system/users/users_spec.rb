require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  describe 'ユーザー登録' do
    context '入力情報が正しい場合' do
      it 'ユーザー登録ができること' do
        visit new_user_path # 新規ユーザー登録画面へ移動
        within '#signup_form' do # id="signup_form"のフォームを指定
          # 以下の情報を登録フォームへ入力
          fill_in 'ユーザー名', with: 'Rails太郎'
          fill_in 'メールアドレス', with: 'rails@example.com'
          fill_in 'パスワード', with: '12345678'
          fill_in 'パスワード確認', with: '12345678'
          click_button '登録' # 登録ボタンをクリック
        end
        expect(current_path).to eq login_path # ログイン画面へ移動すればテスト成功
        expect(page).to have_content 'ユーザーを作成しました' # 「ユーザーを作成しました」と表示されればテスト成功
      end
    end

    context '入力情報に誤りがある場合' do
      it 'ユーザー登録に失敗すること' do
        visit new_user_path # 新規ユーザー登録画面へ移動
        within '#signup_form' do # id="signup_form"のフォームを指定
          # フォームは何も入力しない
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: ''
          fill_in 'パスワード確認', with: ''
          click_button '登録' # 登録ボタンをクリック
        end
        expect(page).to have_content 'ユーザー名を入力してください' #「ユーザー名を入力してください」と表示されればテスト成功
        expect(page).to have_content 'メールアドレスを入力してください' #「メールアドレスを入力してください」と表示されればテスト成功
        expect(page).to have_content 'パスワードは3文字以上で入力してください' #「パスワードは3文字以上で入力してください」と表示されればテスト成功
        expect(page).to have_content 'パスワード確認を入力してください' #「パスワード確認を入力してください」と表示されればテスト成功
        expect(page).to have_content 'ユーザーの作成に失敗しました' #「ユーザーの作成に失敗しました」と表示されればテスト成功
      end
    end
  end

  describe 'フォロー' do
    let!(:login_user) { create(:user) }
    let!(:other_user) { create(:user) }

    before { login_as login_user }
    it 'フォローができること' do
      visit user_path(other_user) # other_userの詳細ページへログイン
      expect {
        click_link 'フォロー' # フォローボタンをクリック
        expect(page).to have_content 'アンフォロー' # アンフォローという表示があればテスト成功
      }.to change(login_user.following, :count).by(1) # フォローしている数が減ればテスト成功
    end

    it 'フォローを外せること' do
      visit user_path(other_user)
      expect {
        click_link 'アンフォロー' # アンフォローボタンをクリック
        expect(page).to have_content 'フォロー' # フォローという表示があればテスト成功
      }.to change(login_user.following, :count).by(-1) # フォローしている数が増えればテスト成功
    end
  end
end
