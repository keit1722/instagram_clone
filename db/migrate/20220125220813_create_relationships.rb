class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end
    add_index :relationships, :follower_id # 高速化の為のインデックス
    add_index :relationships, :followed_id # 高速化の為のインデックス
    add_index :relationships, %i[follower_id followed_id], unique: true # follower_idとfollowed_idの組み合わせに一意性制約を付ける
  end
end
