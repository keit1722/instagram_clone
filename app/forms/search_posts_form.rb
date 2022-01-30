class SearchPostsForm
  include ActiveModel::Model # Active Recordの書き方が使える
  include ActiveModel::Attributes # この記述によりデータ型を指定

  attribute :body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    scope = Post.distinct # Postクラスの重複したインスタンスをなくす処理
    scope =
      splited_bodies
        .map { |splited_body| scope.body_contain(splited_body) }
        .inject { |result, scp| result.or(scp) } if body.present? # splited_bodiesにて返された配列の内の要素一つ一つを検索対象にしている（injectメソッドはループ処理）
    scope = scope.comment_body_contain(comment_body) if comment_body.present?
    scope = scope.username_contain(username) if username.present?
    scope
  end

  private

  def splited_bodies
    # 前後の空白をなくし、文字列の間にある空白ごとに分けて配列にしている
    body.strip.split(/[[:blank:]]+/)
  end
end
