class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :subject, polymorphic: true # subject_type（string型） とsubject_id（bigint型）のカラムが作成される
      t.references :user, foreign_key: true
      t.integer :action_type, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
