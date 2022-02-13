module SystemHelper
  def login # loginメソッドを定義
    user = create(:user) # 新規ユーザ作成
    visit login_path # ログイン画面へ移動
    fill_in 'メールアドレス', with: user.email # メールアドレスの項目に作成したユーザのメールアドレスを入力
    fill_in 'パスワード', with: '12345678' # パスワードの項目に12345678と入力
    click_button 'ログイン' # ログインボタンをクリック
  end

  def login_as(user) # login_asメソッドを定義
    visit login_path # ログイン画面へ移動
    fill_in 'メールアドレス', with: user.email # 引数で渡されたユーザのメールアドレスを入力
    fill_in 'パスワード', with: '12345678' # パスワードの項目に12345678と入力
    click_button 'ログイン' # ログインボタンをクリック
  end
end
