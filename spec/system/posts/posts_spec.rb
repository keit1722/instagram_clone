require 'rails_helper'

RSpec.describe 'ポスト', type: :system do
  describe 'ポスト一覧' do
    # userやpostインスタンスから以下を作成。すべてbeforeの前に実行される。
    let!(:user) { create(:user) } # userを作成（userのインスタンス）
    let!(:post_1_by_others) { create(:post) } # post_1_by_othersを作成（postのインスタンス）
    let!(:post_2_by_others) { create(:post) } # post_2_by_othersを作成（postのインスタンス）
    let!(:post_by_user) { create(:post, user: user) } # post_by_userを作成（postのインスタンス）し、関連付けのuserを先程作成したuserに指定

    context 'ログインしている場合' do
      before do # 「ログインしている場合」のブロック内のexampleの前に実行される処理を記述
        login_as user # 作成したuserでログイン（spec/support/system_helper.rbに書いたlogin_asメソッド）
        user.follow(post_1_by_others.user) # post_1_by_othersの投稿者をuserがフォローする
      end
      it 'フォロワーと自分の投稿だけが表示されること' do
        visit posts_path # 投稿一覧ページへ移動
        expect(page).to have_content post_1_by_others.body #  post_1_by_others（フォローしているユーザの投稿）が表示されていればテスト成功
        expect(page).to have_content post_by_user.body # 自分の投稿が表示されていればテスト成功
        expect(page).not_to have_content post_2_by_others.body # post_2_by_others（フォローしていないユーザの投稿）が表示されていなければテスト成功
      end
    end

    context 'ログインしていない場合' do
      it '全てのポストが表示されること' do
        visit posts_path
        expect(page).to have_content post_1_by_others.body # post_1_by_others（フォローしていないユーザの投稿）が表示されていなければテスト成功
        expect(page).to have_content post_2_by_others.body # post_2_by_others（フォローしていないユーザの投稿）が表示されていなければテスト成功
        expect(page).to have_content post_by_user.body # 自分の投稿が表示されていればテスト成功
      end
    end
  end

  describe 'ポスト投稿' do
    it '画像を投稿できること' do
      login # ログイン（spec/support/system_helper.rbに書いたloginメソッド）
      visit new_post_path # 新規投稿画面へ移動
      within '#posts_form' do # id="posts_form"のフォームを指定
        attach_file '画像', Rails.root.join('spec', 'fixtures', 'fixture.png') # 画像にはspec/fixtures/fixture.pngを添付
        fill_in '本文', with: 'This is an example post' # 本文には「This is an example post」と入力
        click_button '登録する' # 登録ボタンをクリック
      end

      expect(page).to have_content '投稿しました' # 投稿しましたと表示されればテスト成功
      expect(page).to have_content 'This is an example post' # 本文に入力した「This is an example post」が表示されればテスト成功
    end
  end

  describe 'ポスト更新' do
    let!(:user) { create(:user) }
    let!(:post_1_by_others) { create(:post) }
    let!(:post_2_by_others) { create(:post) }
    let!(:post_by_user) { create(:post, user: user) }
    before { login_as user } # ポスト更新のブロック内のexampleの前にはuserとしてログインする処理が実行される
    it '自分の投稿に編集ボタンが表示されること' do
      visit posts_path
      within "#post-#{post_by_user.id}" do # id="post-#{post.id}"のフォームを指定
        expect(page).to have_css '.delete-button' # class="delete-button"のエレメントが表示されていればテスト成功
        expect(page).to have_css '.edit-button' # class="edit-button"のエレメントが表示されていればテスト成功
      end
    end

    it '他人の投稿には編集ボタンが表示されないこと' do
      user.follow(post_1_by_others.user) # userがpost_1_by_othersの投稿者をフォローする
      visit posts_path
      within "#post-#{post_1_by_others.id}" do
        expect(page).not_to have_css '.edit-button' # class="edit-button"のエレメントが表示されていなければテスト成功
      end
    end

    it '投稿が更新できること' do
      visit edit_post_path(post_by_user) # 編集画面へ移動
      within '#posts_form' do
        attach_file '画像', Rails.root.join('spec', 'fixtures', 'fixture.png') # 画像にはspec/fixtures/fixture.pngを添付
        fill_in '本文', with: 'This is an example updated post' # 本文には「This is an example updated post」と入力
        click_button '更新する' # 更新ボタンをクリック
      end
      expect(page).to have_content '投稿を更新しました' # 「投稿を更新しました」と表示されればテスト成功
      expect(page).to have_content 'This is an example updated post' # 本文に入力した「This is an example updated post」が表示されればテスト成功
    end
  end

  describe 'ポスト削除' do
    let!(:user) { create(:user) }
    let!(:post_1_by_others) { create(:post) }
    let!(:post_by_user) { create(:post, user: user) }
    before { login_as user }
    it '自分の投稿に削除ボタンが表示されること' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        expect(page).to have_css '.delete-button'  # class="delete-button"のエレメントが表示されていればテスト成功
      end
    end

    it '他人の投稿には削除ボタンが表示されないこと' do
      user.follow(post_1_by_others.user)
      visit posts_path
      within "#post-#{post_1_by_others.id}" do
        expect(page).not_to have_css '.delete-button' # class="delete-button"のエレメントが表示されていなければテスト成功
      end
    end

    it '投稿が削除できること' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        page.accept_confirm { find('.delete-button').click } # 削除ボタンを押したときに表示されるダイヤログのOKをクリック
      end
      expect(page).to have_content '投稿を削除しました' # 「投稿を削除しました」と表示されればテスト成功
      expect(page).not_to have_content post_by_user.body # 削除した投稿が表示されていなければテスト成功
    end
  end

  describe 'ポスト詳細' do
    let(:user) { create(:user) }
    let(:post_by_user) { create(:post, user: user) }

    before { login_as user }

    it '投稿の詳細画面が閲覧できること' do
      visit post_path(post_by_user) # post_by_user（userの投稿）の投稿詳細画面へ移動
      expect(current_path).to eq post_path(post_by_user) # 移動したページのエンドポイントがpost_path(post_by_user)と同じであればテスト成功
    end
  end
end
